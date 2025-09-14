import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/cache/ram_cache.dart';
import '../../../../../domain/entities/message/message.dart';
import '../../../../../domain/entities/user_entity.dart';
import '../../../../../domain/usecases/fetch_member_in_workspace_use_case.dart';
import '../../../../../domain/usecases/get_pinned_message_summary_workspace_use_case.dart';
import '../../../../../domain/usecases/message/fetch_messages_workspace_use_case.dart';
import '../../../../../domain/usecases/message/send_message_use_case.dart';
import '../../../../../domain/usecases/search_member_in_workspace_use_case.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../../shared/helpers/chat_message_helper.dart';
import '../../../../base/base_state.dart';
import '../../../mappers/pinned_message_summary_mapper.dart';
import '../../../ui_models/pinned_message_summary_ui_model.dart';
import '../../../ui_models/chat_message_ui_model.dart';

part 'workspace_detail_event.dart';

part 'workspace_detail_state.dart';

@injectable
class WSDetailBloc extends BaseBloc<WSDetailEvent, WSDetailState> {
  WSDetailBloc({
    required String userId,
    required int workspaceId,
    required FetchMessagesWorkspaceUseCase fetchMessageUseCase,
    required GetPinnedMessageSummaryWorkspaceUseCase
    getPinnedMessageSummaryWorkspaceUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required FetchMemberInWorkspaceUseCase fetchMemberInWorkspaceUseCase,
    required SearchMemberInWorkspaceUseCase searchMemberInWorkspaceUseCase,
    required RamCache ramCache,
  }) : _workspaceId = workspaceId,
       _userId = userId,
       _fetchMessageUseCase = fetchMessageUseCase,
       _getPinnedMessageSummaryWorkspaceUseCase =
           getPinnedMessageSummaryWorkspaceUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _fetchMemberInWorkspaceUseCase = fetchMemberInWorkspaceUseCase,
       _searchMemberInWorkspaceUseCase = searchMemberInWorkspaceUseCase,
       _ramCache = ramCache,
       super(WSDetailState()) {
    _registerHandlers();
    _initializeMessageListener();
  }

  final int _workspaceId;

  int get workspaceId => _workspaceId;
  final String _userId;

  String get userId => _userId;

  final int _limit = 20;

  final FetchMessagesWorkspaceUseCase _fetchMessageUseCase;
  final GetPinnedMessageSummaryWorkspaceUseCase
  _getPinnedMessageSummaryWorkspaceUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final FetchMemberInWorkspaceUseCase _fetchMemberInWorkspaceUseCase;
  final SearchMemberInWorkspaceUseCase _searchMemberInWorkspaceUseCase;
  final RamCache _ramCache;

  StreamSubscription<MessageEntity>? _messageSubscription;
  StreamSubscription<String>? _tagQuerySubscription;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<CloseReplyMessageEvent>(_onCloseReplyMessage);
    handleSubEvent<ToggleShowScrollToBottomIcon>(
      _onToggleShowScrollToBottomIcon,
    );
    handleSubEvent<ReplyToMessageEvent>(_onReplyToMessage);
    handleSubEvent<SendMessageEvent>(_onSendMessage);
    handleSubEvent<ResetScrollToBottomEvent>(_onDisableIsNeedScrollToBottom);
    handleSubEvent<AddMessageEvent>(
      _onAddMessage,
      // Ensures that each event of the same type is processed before the next event of the same type begins.
      transformer: sequential(),
    );
    handleSubEvent<UpdateHasOptionsEvent>(_onUpdateHasOptions);
    handleSubEvent<UpdateHasSendButtonEvent>(_onUpdateHasSendButton);
    handleSubEvent<FetchMembersEvent>(_onFetchMembers);
    handleSubEvent<SearchMembersEvent>(_onSearchMembers);
    handleSubEvent<JumpToMessageEvent>(_onJumpToMessage);
    handleSubEvent<ResetJumpToMessageEvent>(_onResetJumpToMessage);
    handleSubEvent<ShowTimeEvent>(_onShowTime);
    handleSubEvent<DisableShowTimeEvent>(_onDisableShowTime);
    handleSubEvent<GetPinnedMessageSummaryEvent>(_onGetPinnedMessageSummary);
    handleSubEvent<LoadMoreChatMessagesEvent>(
      _onLoadMoreMessages,
      // droppable to ensure that only one load more request is processed at a time
      transformer: droppable(),
    );
  }

  void _initializeMessageListener() {
    _messageSubscription = _ramCache.getMessageStream().listen(
      (message) {
        add(AddMessageEvent(message: message));
      },
      onError: (_) {
        // TODO hoank: Handle this case.
      },
    );
  }

  void listenTagQuery(Stream<String> tagQueryStream) {
    _tagQuerySubscription?.cancel();
    _tagQuerySubscription = tagQueryStream.listen((query) {
      add(SearchMembersEvent(query: query));
    });
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final result = await _fetchMessageUseCase.call(
      FetchMessagesWorkspaceParams(workspaceId: _workspaceId, limit: _limit),
    );

    final pinnedMessageSummaryResult =
        await _getPinnedMessageSummaryWorkspaceUseCase.call(
          GetPinnedMessageSummaryWorkspaceParams(workspaceId: _workspaceId),
        );

    final pinnedMessageSummary = PinnedMessageSummaryMapper.fromMessageEntity(
      pinnedMessageSummaryResult,
    );

    final messages = result.data;
    final pagingStatus = messages.isEmpty
        ? PagingStatus.empty
        : (result.totalRecords == _limit
              ? PagingStatus.noMoreData
              : PagingStatus.loadCompleted);

    emit(
      state.copyWith(
        isInitialized: true,
        pageStatus: PageStatus.loaded,
        chatMessages: messages.isEmpty ? [] : _mapMessagesToUIModels(messages),
        chatMessagesPagingStatus: pagingStatus,
        pinnedMessageSummary: pinnedMessageSummary,
        initIndex: messages.isEmpty ? 0 : messages.length - 1,
      ),
    );
  }

  Future<void> _onLoadMoreMessages(
    LoadMoreChatMessagesEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    if (!state.needLoadMoreOldMessages) return;
    emit(state.copyWith(chatMessagesPagingStatus: PagingStatus.loading));

    final result = await _fetchMessageUseCase.call(
      FetchMessagesWorkspaceParams(
        workspaceId: _workspaceId,
        limit: _limit,
        oldestMessageId: state.chatMessages.first.message.id,
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    final messages = result.data;
    final pagingStatus = messages.isEmpty || result.data.length == _limit
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;

    // insert messages to the beginning of the list
    final newMessages = _mapMessagesToUIModels(messages);
    final newChatMessages = [...newMessages, ...state.chatMessages];

    // update last ui models of new messages list to map to first state.chatMessages
    final updatedMessages = _updateUIModel(
      newChatMessages,
      newMessages.length - 1,
    );

    emit(
      state.copyWith(
        chatMessages: updatedMessages,
        chatMessagesPagingStatus: pagingStatus,
        initIndex: newMessages.isEmpty ? 0 : newMessages.length - 1,
      ),
    );
  }

  Future<void> _onCloseReplyMessage(
    CloseReplyMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    if (state.messageReply != null) {
      emit(state.copyWith(forceCloseReplyMessage: true));
    }
  }

  Future<void> _onToggleShowScrollToBottomIcon(
    ToggleShowScrollToBottomIcon event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(showScrollToBottomIcon: !state.showScrollToBottomIcon));
  }

  Future<void> _onReplyToMessage(
    ReplyToMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(messageReply: event.message));
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final reply = state.messageReply;

    add(CloseReplyMessageEvent());

    _sendMessageUseCase.call(
      SendMessageParams(
        userId: userId,
        workspaceId: _workspaceId,
        replyMessageId: reply?.id,
        content: event.content,
      ),
    );
  }

  Future<void> _onDisableIsNeedScrollToBottom(
    ResetScrollToBottomEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(scrollToBottom: false));
  }

  Future<void> _onAddMessage(
    AddMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final message = event.message;
    final uiModel = message.toUIModel(
      previousMessage: state.chatMessages.isNotEmpty
          ? state.chatMessages.last.message
          : null,
      nextMessage: null,
    );
    final chatMessages = [...state.chatMessages, uiModel];
    final messageIndex = chatMessages.length - 1;
    final updatedListUiModel = _updateUIModel(chatMessages, messageIndex);

    emit(state.copyWith(chatMessages: updatedListUiModel));
  }

  Future<void> _onUpdateHasOptions(
    UpdateHasOptionsEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(hasOptions: event.hasOptions));
  }

  Future<void> _onUpdateHasSendButton(
    UpdateHasSendButtonEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(hasSendButton: event.hasSendButton));
  }

  Future<void> _onFetchMembers(
    FetchMembersEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final users = await _fetchMemberInWorkspaceUseCase.call(
      FetchMemberInWorkspaceParams(
        workspaceId: _workspaceId,
        limit: _limit,
        offset: 0,
      ),
    );
    emit(state.copyWith(users: users));
  }

  Future<void> _onSearchMembers(
    SearchMembersEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(users: []));
      return;
    }
    final users = await _searchMemberInWorkspaceUseCase.call(
      SearchMemberInWorkspaceParams(
        workspaceId: _workspaceId,
        query: event.query,
      ),
    );
    emit(state.copyWith(users: users));
  }

  Future<void> _onJumpToMessage(
    JumpToMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final messageIndex = state.chatMessages.indexWhere(
      (uiModel) => uiModel.message.id == event.messageId,
    );
    if (messageIndex == -1 && state.needLoadMoreOldMessages) {
      emit(state.copyWith(chatMessagesPagingStatus: PagingStatus.loading));

      final result = await _fetchMessageUseCase.call(
        FetchMessagesWorkspaceParams(
          workspaceId: _workspaceId,
          limit: _limit,
          oldestMessageId: state.chatMessages.first.message.id,
          targetMessageId: event.messageId,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      final messages = result.data;
      final pagingStatus = messages.isEmpty || result.data.length == _limit
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;

      // insert messages to the beginning of the list
      final newMessages = _mapMessagesToUIModels(messages);
      final newChatMessages = [...newMessages, ...state.chatMessages];

      // update last ui models of new messages list to map to first state.chatMessages
      final updatedMessages = _updateUIModel(
        newChatMessages,
        newMessages.length - 1,
      );

      final jumpToMessageIndex = updatedMessages.indexWhere(
        (uiModel) => uiModel.message.id == event.messageId,
      );

      if (jumpToMessageIndex != -1) {
        emit(
          state.copyWith(
            chatMessages: updatedMessages,
            chatMessagesPagingStatus: pagingStatus,
            jumpToMessageIndex: jumpToMessageIndex,
          ),
        );
      } else {
        emit(
          state.copyWith(
            chatMessages: updatedMessages,
            chatMessagesPagingStatus: pagingStatus,
          ),
        );
      }
    } else {
      emit(state.copyWith(jumpToMessageIndex: messageIndex));
    }
  }

  Future<void> _onResetJumpToMessage(
    ResetJumpToMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(forceCloseJumpToMessage: true));
  }

  Future<void> _onShowTime(
    ShowTimeEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final messageIndex = state.chatMessages.indexWhere(
      (uiModel) => uiModel.message.id == event.messageId,
    );
    if (messageIndex == -1) return;
    final updatedMessages = _updateUIModel(
      state.chatMessages,
      messageIndex,
      forceShowTime: true,
    );
    emit(
      state.copyWith(
        chatMessages: updatedMessages,
        showTimeMessageId: event.messageId,
      ),
    );
  }

  Future<void> _onDisableShowTime(
    DisableShowTimeEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final messageIndex = state.chatMessages.indexWhere(
      (uiModel) => uiModel.message.id == state.showTimeMessageId,
    );
    if (messageIndex == -1) return;
    final updatedMessages = _updateUIModel(
      state.chatMessages,
      messageIndex,
      forceShowTime: false,
    );
    emit(
      state.copyWith(chatMessages: updatedMessages, forceDisableShowTime: true),
    );
  }

  Future<void> _onGetPinnedMessageSummary(
    GetPinnedMessageSummaryEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final pinnedMessageSummary = await _getPinnedMessageSummaryWorkspaceUseCase
        .call(
          GetPinnedMessageSummaryWorkspaceParams(workspaceId: _workspaceId),
        );

    final uiModel = PinnedMessageSummaryMapper.fromMessageEntity(
      pinnedMessageSummary,
    );

    emit(state.copyWith(pinnedMessageSummary: uiModel));
  }

  // Functions
  List<ChatMessageUIModel> _mapMessagesToUIModels(
    List<MessageEntity> messages,
  ) {
    final List<ChatMessageUIModel> uiModels = [];

    for (int i = 0; i < messages.length; i++) {
      final uiModel = messages[i].toUIModel(
        previousMessage: i > 0 ? messages[i - 1] : null,
        nextMessage: i < messages.length - 1 ? messages[i + 1] : null,
      );
      uiModels.add(uiModel);
    }

    return uiModels;
  }

  List<ChatMessageUIModel> _updateUIModel(
    List<ChatMessageUIModel> chatMessages,
    int messageIndex, {
    bool? forceShowTime,
  }) {
    final updatedMessages = List<ChatMessageUIModel>.from(chatMessages);
    final currentMessage = forceShowTime != null
        ? chatMessages[messageIndex].copyWith(shouldShowTime: forceShowTime)
        : chatMessages[messageIndex];
    updatedMessages[messageIndex] = currentMessage;

    // Xử lý previous message và next message
    // với mỗi previous message và next message, cần check lại cả previous của previous message, next message cần check lại cả next của next message

    final previousMessage = messageIndex > 0
        ? updatedMessages[messageIndex - 1]
        : null;
    final nextMessage = messageIndex < chatMessages.length - 1
        ? updatedMessages[messageIndex + 1]
        : null;
    if (previousMessage != null) {
      final previousPreviousMessage = messageIndex > 1
          ? updatedMessages[messageIndex - 2]
          : null;

      if (previousPreviousMessage != null) {
        final (
          shouldShowTime,
          shouldShowAvatar,
          shouldShowUserName,
          isContinuation,
        ) = ChatMessageHelper.updateUIModel(
          currentMessage: previousMessage,
          previousMessage: previousPreviousMessage,
          nextMessage: currentMessage,
        );
        updatedMessages[messageIndex - 1] = previousMessage.copyWith(
          shouldShowTime: shouldShowTime,
          shouldShowAvatar: shouldShowAvatar,
          shouldShowUserName: shouldShowUserName,
          isContinuation: isContinuation,
        );
      }
    }

    if (nextMessage != null) {
      final nextNextMessage = messageIndex < updatedMessages.length - 2
          ? chatMessages[messageIndex + 2]
          : null;
      if (nextNextMessage != null) {
        final (
          shouldShowTime,
          shouldShowAvatar,
          shouldShowUserName,
          isContinuation,
        ) = ChatMessageHelper.updateUIModel(
          currentMessage: nextMessage,
          previousMessage: currentMessage,
          nextMessage: nextNextMessage,
        );
        updatedMessages[messageIndex + 1] = nextMessage.copyWith(
          shouldShowTime: shouldShowTime,
          shouldShowAvatar: shouldShowAvatar,
          shouldShowUserName: shouldShowUserName,
          isContinuation: isContinuation,
        );
      }
    }

    return updatedMessages;
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _tagQuerySubscription?.cancel();
    return super.close();
  }
}
