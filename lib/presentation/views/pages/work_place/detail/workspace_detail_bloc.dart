import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../../data/cache/ram_cache.dart';
import '../../../../../domain/entities/message/message.dart';
import '../../../../../domain/entities/user_entity.dart';
import '../../../../../domain/enums/message_enums.dart';
import '../../../../../domain/usecases/fetch_current_user_use_case.dart';
import '../../../../../domain/usecases/fetch_member_in_workspace_use_case.dart';
import '../../../../../domain/usecases/fetch_pinned_message_use_case.dart';
import '../../../../../domain/usecases/get_pinned_message_summary_workspace_use_case.dart';
import '../../../../../domain/usecases/message/fetch_messages_workspace_use_case.dart';
import '../../../../../domain/usecases/message/send_message_use_case.dart';
import '../../../../../domain/usecases/message/unpin_message_use_case.dart';
import '../../../../../domain/usecases/search_member_in_workspace_use_case.dart';
import '../../../../../domain/usecases/use_case.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../base/base_state.dart';
import '../../../mappers/pinned_message_mapper.dart';
import '../../../mappers/pinned_message_summary_mapper.dart';
import '../../../ui_models/pinned_message_ui_model.dart';
import '../../../ui_models/pinned_message_summary_ui_model.dart';
import '../../../ui_models/chat_message_ui_model.dart';

part 'workspace_detail_event.dart';

part 'workspace_detail_state.dart';

@injectable
class WSDetailBloc extends BaseBloc<WSDetailEvent, WSDetailState> {
  WSDetailBloc({
    required int workspaceId,
    required FetchMessagesWorkspaceUseCase fetchMessageUseCase,
    required GetPinnedMessageSummaryWorkspaceUseCase
    getPinnedMessageSummaryWorkspaceUseCase,
    required FetchCurrentUserUseCase fetchCurrentUserUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required FetchMemberInWorkspaceUseCase fetchMemberInWorkspaceUseCase,
    required SearchMemberInWorkspaceUseCase searchMemberInWorkspaceUseCase,
    required FetchPinnedMessageUseCase fetchPinnedMessageUseCase,
    required UnpinMessageUseCase unpinMessageUseCase,
  }) : _workspaceId = workspaceId,
       _fetchMessageUseCase = fetchMessageUseCase,
       _getPinnedMessageSummaryWorkspaceUseCase =
           getPinnedMessageSummaryWorkspaceUseCase,
       _fetchCurrentUserUseCase = fetchCurrentUserUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _fetchMemberInWorkspaceUseCase = fetchMemberInWorkspaceUseCase,
       _searchMemberInWorkspaceUseCase = searchMemberInWorkspaceUseCase,
       _fetchPinnedMessageUseCase = fetchPinnedMessageUseCase,
       _unpinMessageUseCase = unpinMessageUseCase,
       super(WSDetailState()) {
    _registerHandlers();
    _initializeMessageListener();
  }

  final int _workspaceId;
  int get workspaceId => _workspaceId;

  UserEntity? _user;
  String? get userId => _user?.id;

  final int _limit = 20;
  final int _pinnedMessagesLimit = 10;
  int _pinnedMessagesOffset = 0;

  final FetchMessagesWorkspaceUseCase _fetchMessageUseCase;
  final GetPinnedMessageSummaryWorkspaceUseCase
  _getPinnedMessageSummaryWorkspaceUseCase;
  final FetchCurrentUserUseCase _fetchCurrentUserUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final FetchMemberInWorkspaceUseCase _fetchMemberInWorkspaceUseCase;
  final SearchMemberInWorkspaceUseCase _searchMemberInWorkspaceUseCase;
  final FetchPinnedMessageUseCase _fetchPinnedMessageUseCase;
  final UnpinMessageUseCase _unpinMessageUseCase;

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
    handleSubEvent<UpdateMessageEvent>(_onUpdateMessage);
    handleSubEvent<UpdateHasOptionsEvent>(_onUpdateHasOptions);
    handleSubEvent<UpdateHasSendButtonEvent>(_onUpdateHasSendButton);
    handleSubEvent<FetchMembersEvent>(_onFetchMembers);
    handleSubEvent<SearchMembersEvent>(_onSearchMembers);
    handleSubEvent<LoadPinnedMessagesEvent>(_onLoadPinnedMessages);
    handleSubEvent<RefreshPinnedMessagesEvent>(_onRefreshPinnedMessages);
    handleSubEvent<LoadMorePinnedMessagesEvent>(_onLoadMorePinnedMessages);
    handleSubEvent<UnpinMessageFromDetailEvent>(_onUnpinMessageFromDetail);
    handleSubEvent<ResetUnpinSuccessEvent>(_onResetUnpinSuccess);
    handleSubEvent<JumpToMessageEvent>(_onJumpToMessage);
    handleSubEvent<ResetJumpToMessageEvent>(_onResetJumpToMessage);
    handleSubEvent<ShowTimeEvent>(_onShowTime);
    handleSubEvent<DisableShowTimeEvent>(_onDisableShowTime);
    handleSubEvent<GetPinnedMessageSummaryEvent>(_onGetPinnedMessageSummary);
    handleSubEvent<ResetScrollToTopEvent>(_onResetScrollToTop);
  }

  void _initializeMessageListener() {
    _messageSubscription = RamCache().getMessageStream().listen((message) {
      add(UpdateMessageEvent(message: message));
    });
  }

  void listenTagQuery(Stream<String> tagQueryStream) {
    _tagQuerySubscription?.cancel();
    _tagQuerySubscription = tagQueryStream.listen((query) {
      add(SearchMembersEvent(query: query));
    });
  }

  Future<(List<PinnedMessageUIModel>, PagingStatus)?> _getPinnedMessages(
    int offset, {
    bool isRefresh = false,
  }) async {
    final result = await _fetchPinnedMessageUseCase.call(
      FetchPinnedMessageParams(
        workspaceId: _workspaceId,
        limit: _pinnedMessagesLimit,
        offset: offset,
      ),
    );

    final pagedResult = result.data;
    final messages = pagedResult
        .map((e) => PinnedMessageMapper.fromMessageEntity(e))
        .toList();

    final currentPage = (offset / _pinnedMessagesLimit).floor() + 1;
    final totalRecords = result.totalRecords;
    final totalPages = (totalRecords / _pinnedMessagesLimit).ceil();
    final isLastPage = currentPage >= totalPages;

    final fetchStatus = messages.isEmpty
        ? PagingStatus.empty
        : (isLastPage
              ? PagingStatus.noMoreData
              : (isRefresh
                    ? PagingStatus.refreshCompleted
                    : PagingStatus.loadCompleted));

    return (messages, fetchStatus);
  }

  List<ChatMessageUIModel> _mapMessagesToUIModels(
    List<MessageEntity> messages, {
    String? showTimeMessageId,
  }) {
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final List<ChatMessageUIModel> uiModels = [];

    for (int i = 0; i < messages.length; i++) {
      final uiModel = messages[i].toUIModel(
        previousMessage: i > 0 ? messages[i - 1] : null,
        nextMessage: i < messages.length - 1 ? messages[i + 1] : null,
        forceShowTime:
            (showTimeMessageId ?? state.showTimeMessageId) == messages[i].id,
      );
      uiModels.add(uiModel);
    }

    return uiModels;
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

    final userResult = await _fetchCurrentUserUseCase(NoParam());
    _user = userResult;

    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        chatMessages: _mapMessagesToUIModels(result.data),
        pinnedMessageSummary: pinnedMessageSummary,
      ),
    );
  }

  Future<void> _onLoadPinnedMessages(
    LoadPinnedMessagesEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));
    _pinnedMessagesOffset = 0;

    final result = await _getPinnedMessages(_pinnedMessagesOffset);
    if (result == null) {
      emit(state.copyWith(pageStatus: PageStatus.failure));
      return;
    }

    final (messages, pagingStatus) = result;
    _pinnedMessagesOffset = messages.length;
    emit(
      state.copyWith(
        pinnedMessages: messages,
        pinnedMessagesPagingStatus: pagingStatus,
      ),
    );
  }

  Future<void> _onRefreshPinnedMessages(
    RefreshPinnedMessagesEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    if (state.pinnedMessagesPagingStatus == PagingStatus.refreshing) return;

    _pinnedMessagesOffset = 0;
    emit(
      state.copyWith(
        processing: true,
        pinnedMessagesPagingStatus: PagingStatus.refreshing,
      ),
    );

    final result = await _getPinnedMessages(
      _pinnedMessagesOffset,
      isRefresh: true,
    );
    if (result == null) {
      emit(
        state.copyWith(
          processing: false,
          pinnedMessagesPagingStatus: PagingStatus.refreshFailed,
        ),
      );
      return;
    }

    final (messages, pagingStatus) = result;
    _pinnedMessagesOffset = messages.length;
    emit(
      state.copyWith(
        processing: false,
        pinnedMessagesPagingStatus: pagingStatus,
        pinnedMessages: messages,
      ),
    );
  }

  Future<void> _onLoadMorePinnedMessages(
    LoadMorePinnedMessagesEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    if (state.pinnedMessagesPagingStatus == PagingStatus.loading ||
        state.pinnedMessagesPagingStatus == PagingStatus.noMoreData) {
      return;
    }

    emit(
      state.copyWith(
        processing: true,
        pinnedMessagesPagingStatus: PagingStatus.loading,
      ),
    );

    final result = await _getPinnedMessages(_pinnedMessagesOffset);
    if (result == null) {
      emit(
        state.copyWith(
          processing: false,
          pinnedMessagesPagingStatus: PagingStatus.loadFailed,
        ),
      );
      return;
    }

    final (messages, pagingStatus) = result;
    _pinnedMessagesOffset += messages.length;
    final updatedMessages = [...state.pinnedMessages, ...messages];

    emit(
      state.copyWith(
        processing: false,
        pinnedMessagesPagingStatus: pagingStatus,
        pinnedMessages: updatedMessages,
      ),
    );
  }

  Future<void> _onUnpinMessageFromDetail(
    UnpinMessageFromDetailEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    await _unpinMessageUseCase.call(
      UnpinMessageParams(messageId: event.messageId),
    );

    final messages = List<PinnedMessageUIModel>.from(state.pinnedMessages)
      ..removeWhere((e) => e.id == event.messageId);

    _pinnedMessagesOffset = max(0, _pinnedMessagesOffset - 1);
    emit(
      state.copyWith(
        processing: false,
        pinnedMessages: messages,
        isUnpinSuccess: true,
      ),
    );
  }

  Future<void> _onResetUnpinSuccess(
    ResetUnpinSuccessEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(isUnpinSuccess: false));
  }

  Future<void> _onCloseReplyMessage(
    CloseReplyMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(forceCloseReplyMessage: true));
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
    final user = _user;
    if (user == null) {
      return;
    }

    emit(state.copyWith(scrollToBottom: true));

    try {
      final MessageEntity? sendingMessage = createMessage(user, event.content);

      if (sendingMessage != null) {
        final List<MessageEntity> currentRawMessages = state.chatMessages
            .map((e) => e.message)
            .toList();
        final List<MessageEntity> updatedRawMessages = [
          ...currentRawMessages,
          sendingMessage,
        ];
        emit(
          state.copyWith(
            chatMessages: _mapMessagesToUIModels(updatedRawMessages),
          ),
        );
        await _sendMessageUseCase.call(
          SendMessageParams(message: sendingMessage),
        );
      }
    } catch (e) {
      emit(state.copyWith(pageErrorMessage: e.toString()));
    }
  }

  Future<void> _onDisableIsNeedScrollToBottom(
    ResetScrollToBottomEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(scrollToBottom: false));
  }

  Future<void> _onUpdateMessage(
    UpdateMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final List<MessageEntity> currentRawMessages = state.chatMessages
        .map((e) => e.message)
        .toList();
    final messageIndex = currentRawMessages.indexWhere(
      (message) => message.tempId == event.message.tempId,
    );

    List<MessageEntity> updatedRawMessages = List<MessageEntity>.from(
      currentRawMessages,
    );

    if (messageIndex != -1) {
      // Update existing message
      final MessageEntity updatedMessage = updatedRawMessages[messageIndex]
          .copyWith(status: event.message.status);
      updatedRawMessages[messageIndex] = updatedMessage;
    } else {
      // Add new message
      updatedRawMessages.add(event.message);
    }

    emit(
      state.copyWith(chatMessages: _mapMessagesToUIModels(updatedRawMessages)),
    );
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

  MessageEntity? createMessage(UserEntity user, dynamic content) {
    MessageEntity? message;
    if (content is TextMessageContent) {
      message = MessageEntity(
        tempId: Uuid().v4(),
        sender: MessageSender(
          id: user.id,
          name: user.name,
          avatarUrl: user.avatar,
        ),
        createdAt: DateTime.now(),
        type: MessageType.text,
        content: content,
        status: MessageStatus.pending,
        workspaceId: _workspaceId,
        reply: state.messageReply != null
            ? createMessageReply(state.messageReply!)
            : null,
      );
    }

    return message;
  }

  MessageReply createMessageReply(MessageEntity message) {
    var reply = MessageReply(
      messageId: message.id!,
      senderId: message.sender.id,
      senderName: message.sender.name,
      originalMessageType: message.type,
    );

    switch (message.type) {
      case MessageType.text:
        reply = reply.copyWith(
          previewText: (message.content as TextMessageContent).text,
        );
        break;
      case MessageType.image:
        reply = reply.copyWith(
          previewImageUrl: (message.content as ImageMessageContent).imageUrl,
        );
        break;
      case MessageType.video:
        reply = reply.copyWith(
          previewThumbnailUrl:
              (message.content as VideoMessageContent).thumbnailUrl,
        );
        break;
      case MessageType.file:
        reply = reply.copyWith(
          previewFileName: (message.content as FileMessageContent).fileName,
        );
        break;
      default:
        break;
    }

    return reply;
  }

  Future<void> _onJumpToMessage(
    JumpToMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final messageIndex = state.chatMessages.indexWhere(
      (uiModel) => uiModel.message.id == event.messageId,
    );
    if (messageIndex == -1) {
      emit(state.copyWith(scrollToTop: true));
      final messageResult = await _fetchMessageUseCase.call(
        FetchMessagesWorkspaceParams(
          workspaceId: _workspaceId,
          limit: _limit,
          oldestMessageId: state.chatMessages.first.message.id,
        ),
      );
      final messages = messageResult.data;
      final messageIndex = messages.indexWhere(
        (message) => message.id == event.messageId,
      );
      emit(
        state.copyWith(
          chatMessages: _mapMessagesToUIModels(messages),
          jumpToMessageIndex: messageIndex,
        ),
      );
      return;
    }
    emit(state.copyWith(jumpToMessageIndex: messageIndex));
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
    final newMessages = _mapMessagesToUIModels(
      state.chatMessages.map((e) => e.message).toList(),
      showTimeMessageId: event.messageId,
    );
    emit(
      state.copyWith(
        chatMessages: newMessages,
        showTimeMessageId: event.messageId,
      ),
    );
  }

  Future<void> _onDisableShowTime(
    DisableShowTimeEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final newMessages = _mapMessagesToUIModels(
      state.chatMessages.map((e) => e.message).toList(),
      showTimeMessageId: null,
    );
    emit(state.copyWith(chatMessages: newMessages, forceDisableShowTime: true));
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

  Future<void> _onResetScrollToTop(
    ResetScrollToTopEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(scrollToTop: false));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _tagQuerySubscription?.cancel();
    return super.close();
  }
}
