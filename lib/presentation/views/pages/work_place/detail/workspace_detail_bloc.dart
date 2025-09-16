import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/cache/ram_cache.dart';
import '../../../../../dependencies/media/media_manager.dart';
import '../../../../../dependencies/file/file_manager.dart';
import '../../../../../domain/entities/message/message.dart';
import '../../../../../domain/enums/message_enums.dart';
import '../../../../../domain/entities/user_entity.dart';
import '../../../../../domain/enums/send_message_type.dart';
import '../../../../../domain/usecases/fetch_member_in_workspace_use_case.dart';
import '../../../../../domain/usecases/get_pinned_message_summary_workspace_use_case.dart';
import '../../../../../domain/usecases/message/fetch_messages_workspace_use_case.dart';
import '../../../../../domain/usecases/message/send_message_use_case.dart';
import '../../../../../domain/usecases/message/unpin_message_use_case.dart';
import '../../../../../domain/usecases/message/pin_message_use_case.dart';
import '../../../../../domain/usecases/search_member_in_workspace_use_case.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../../shared/helpers/chat_message_helper.dart';
import '../../../../../shared/utils/tag_user_text_editing_controller.dart';
import '../../../../base/base_state.dart';
import '../../../mappers/pinned_message_summary_mapper.dart';
import '../../../ui_models/pinned_message_summary_ui_model.dart';
import '../../../ui_models/chat_message_ui_model.dart';

part 'workspace_detail_event.dart';

part 'workspace_detail_state.dart';

@injectable
class WSDetailBloc extends BaseBloc<WSDetailEvent, WSDetailState> {
  WSDetailBloc({
    required FetchMessagesWorkspaceUseCase fetchMessageUseCase,
    required GetPinnedMessageSummaryWorkspaceUseCase
    getPinnedMessageSummaryWorkspaceUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required FetchMemberInWorkspaceUseCase fetchMemberInWorkspaceUseCase,
    required SearchMemberInWorkspaceUseCase searchMemberInWorkspaceUseCase,
    required UnpinMessageUseCase unpinMessageUseCase,
    required PinMessageUseCase pinMessageUseCase,
    required RamCache ramCache,
    required MediaManager mediaManager,
    required FileManager fileManager,
  }) : _fetchMessageUseCase = fetchMessageUseCase,
       _getPinnedMessageSummaryWorkspaceUseCase =
           getPinnedMessageSummaryWorkspaceUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _fetchMemberInWorkspaceUseCase = fetchMemberInWorkspaceUseCase,
       _searchMemberInWorkspaceUseCase = searchMemberInWorkspaceUseCase,
       _unpinMessageUseCase = unpinMessageUseCase,
       _pinMessageUseCase = pinMessageUseCase,
       _ramCache = ramCache,
       _mediaManager = mediaManager,
       _fileManager = fileManager,
       super(WSDetailState()) {
    _registerHandlers();
    _initializeListener();
  }

  late final int workspaceId;
  final FetchMessagesWorkspaceUseCase _fetchMessageUseCase;
  final GetPinnedMessageSummaryWorkspaceUseCase
  _getPinnedMessageSummaryWorkspaceUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final FetchMemberInWorkspaceUseCase _fetchMemberInWorkspaceUseCase;
  final SearchMemberInWorkspaceUseCase _searchMemberInWorkspaceUseCase;
  final UnpinMessageUseCase _unpinMessageUseCase;
  final PinMessageUseCase _pinMessageUseCase;

  final MediaManager _mediaManager;
  final FileManager _fileManager;
  final RamCache _ramCache;

  StreamSubscription<MessageEntity>? _messageSubscription;
  StreamSubscription<String>? _tagQuerySubscription;
  StreamSubscription<bool>? _showTagOverlaySubscription;

  final String _userId = '1';
  final int _limit = 20;
  final TagUserTextEditingController _textEditingController =
      TagUserTextEditingController();

  String get userId => _userId;

  TagUserTextEditingController get textEditingController =>
      _textEditingController;

  List<TextSegment> detectLinkTextSegment(String text) {
    final regex = RegExp(r'https?://\S+');
    final match = regex.allMatches(text);
    if (match.isEmpty) {
      return [];
    }

    return match
        .map(
          (e) => TextSegment(
            type: TextSegmentType.link,
            start: e.start,
            end: e.end,
            extra: e.group(0)!,
          ),
        )
        .toList();
  }

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
    handleSubEvent<UnpinMessageFromDetailEvent>(_onUnpinMessage);
    handleSubEvent<PinMessageFromDetailEvent>(_onPinMessage);
    handleSubEvent<ResetPinStatusSuccessEvent>(_onResetPinStatusSuccess);
    handleSubEvent<UpdateShowTagOverlayEvent>(_onUpdateShowTagOverlay);
  }

  void _initializeListener() {
    // Listen to message stream
    _messageSubscription = _ramCache.getMessageStream().listen(
      (message) {
        if (message.workspaceId != workspaceId) return;
        add(AddMessageEvent(message: message));
        if (message.sender.id == userId) {
          add(JumpToMessageEvent(messageId: message.id));
        }
      },
      onError: (_) {
        // TODO hoank: Handle this case.
      },
    );

    // Listen to text editing controller streams
    _showTagOverlaySubscription = _textEditingController.showTagOverlay.listen((
      show,
    ) {
      add(UpdateShowTagOverlayEvent(showTagOverlay: show));
    });

    _tagQuerySubscription = _textEditingController.tagQuery.listen((query) {
      add(SearchMembersEvent(query: query));
    });

    // Listen to text changes for send button
    _textEditingController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final input = _textEditingController.text;

    if (state.hasSendButton && input.isEmpty) {
      add(UpdateHasSendButtonEvent(hasSendButton: false));
    } else if (!state.hasSendButton && input.isNotEmpty) {
      add(UpdateHasSendButtonEvent(hasSendButton: true));
    }
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final result = await _fetchMessageUseCase.call(
      FetchMessagesWorkspaceParams(workspaceId: workspaceId, limit: _limit),
    );

    final messages = result.data;
    final pagingStatus = messages.isEmpty
        ? PagingStatus.empty
        : (result.totalRecords <= _limit
              ? PagingStatus.noMoreData
              : PagingStatus.loadCompleted);

    final pinnedMessageSummaryResult =
        await _getPinnedMessageSummaryWorkspaceUseCase.call(
          GetPinnedMessageSummaryWorkspaceParams(workspaceId: workspaceId),
        );

    final pinnedMessageSummary = PinnedMessageSummaryMapper.fromMessageEntity(
      pinnedMessageSummaryResult,
    );

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
        workspaceId: workspaceId,
        limit: _limit,
        oldestMessageId: state.chatMessages.first.message.id,
      ),
    );

    // TODO hoannk: Remove delay
    await Future.delayed(const Duration(seconds: 2));

    final messages = result.data;
    final pagingStatus = messages.isEmpty
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;

    final updatedMessages = _addMessageList(leadingMessageList: messages);

    emit(
      state.copyWith(
        chatMessages: updatedMessages,
        chatMessagesPagingStatus: pagingStatus,
        // Giữ vị trí là ví trị của message cuối cùng của list vừa được thêm để
        // tạo thêm cảm giác được scroll tiếp cho load more kế tiếp
        initIndex: messages.isEmpty ? 0 : messages.length - 1,
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

    dynamic content;
    if (event.type == SendMessageType.text) {
      final tagTextSegments = _textEditingController.tagTextSegments;
      final linkTextSegments = detectLinkTextSegment(
        _textEditingController.text,
      );
      final textSegments = [...tagTextSegments, ...linkTextSegments];
      content = TextMessageContent(
        text: _textEditingController.text,
        textSegments: textSegments,
      );
    } else if (event.type == SendMessageType.file) {
      final result = await _fileManager.pickFiles();
      if (result == null) return;
      final file = result.first;

      content = FileMessageContent(
        fileUrl: '',
        fileName: file.name,
        fileExtension: file.extension ?? '',
        fileSize: file.size,
        path: file.path,
      );
    } else if (event.type == SendMessageType.media) {
      final result = await _mediaManager.pickMedia();
      if (result == null) return;
      bool? isPhoto;

      if (result.path.isImage()) isPhoto = true;
      if (result.path.isVideo()) isPhoto = false;
      if (isPhoto == null) return;

      if (isPhoto) {
        content = ImageMessageContent(imageUrl: '', path: result.path);
      } else {
        content = VideoMessageContent(
          videoUrl: '',
          duration: Duration(seconds: 0),
          path: result.path,
        );
      }
    }

    await _sendMessageUseCase.call(
      SendMessageParams(
        userId: userId,
        workspaceId: workspaceId,
        replyMessageId: reply?.id,
        content: content,
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
        workspaceId: workspaceId,
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
        workspaceId: workspaceId,
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
          workspaceId: workspaceId,
          limit: _limit,
          oldestMessageId: state.chatMessages.first.message.id,
          targetMessageId: event.messageId,
        ),
      );

      // TODO hoannk: Remove delay
      await Future.delayed(const Duration(seconds: 2));

      final messages = result.data;
      final pagingStatus = messages.isEmpty || result.data.length == _limit
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;

      final updatedMessages = _addMessageList(leadingMessageList: messages);

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

  Future<void> _onUnpinMessage(
    UnpinMessageFromDetailEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(processing: true));
    final messageIndex = state.chatMessages.indexWhere(
      (uiModel) => uiModel.message.id == event.messageId,
    );
    if (messageIndex == -1) return;

    await _unpinMessageUseCase.call(
      UnpinMessageParams(messageId: event.messageId),
    );
    // TODO hoannk: Remove delay
    await Future.delayed(const Duration(seconds: 2));

    final messages = List<ChatMessageUIModel>.from(state.chatMessages);
    final currentMessage = messages[messageIndex];
    messages[messageIndex] = currentMessage.copyWith(
      message: currentMessage.message.copyWith(isPinned: false),
    );

    emit(
      state.copyWith(
        chatMessages: messages,
        isPinStatusSuccess: true,
        processing: false,
      ),
    );
  }

  Future<void> _onResetPinStatusSuccess(
    ResetPinStatusSuccessEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(isPinStatusSuccess: false));
  }

  Future<void> _onPinMessage(
    PinMessageFromDetailEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(processing: true));
    final messageIndex = state.chatMessages.indexWhere(
      (uiModel) => uiModel.message.id == event.messageId,
    );
    if (messageIndex == -1) return;

    await _pinMessageUseCase.call(PinMessageParams(messageId: event.messageId));
    // TODO hoannk: Remove delay
    await Future.delayed(const Duration(seconds: 2));

    final messages = List<ChatMessageUIModel>.from(state.chatMessages);
    final currentMessage = messages[messageIndex];
    messages[messageIndex] = currentMessage.copyWith(
      message: currentMessage.message.copyWith(isPinned: true),
    );

    emit(
      state.copyWith(
        chatMessages: messages,
        isPinStatusSuccess: true,
        processing: false,
      ),
    );
  }

  Future<void> _onUpdateShowTagOverlay(
    UpdateShowTagOverlayEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(showTagOverlay: event.showTagOverlay));
  }

  Future<void> _onGetPinnedMessageSummary(
    GetPinnedMessageSummaryEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final pinnedMessageSummary = await _getPinnedMessageSummaryWorkspaceUseCase
        .call(GetPinnedMessageSummaryWorkspaceParams(workspaceId: workspaceId));

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

  List<ChatMessageUIModel> _addMessageList({
    List<MessageEntity>? leadingMessageList,
    List<MessageEntity>? trailingMessageList,
  }) {
    var updatedMessages = List<ChatMessageUIModel>.from(state.chatMessages);
    // Mỗi khi thêm list mới sẽ update list vào list cũ và cập nhật phần từ nối
    // giữa 2 mảng
    // ví dụ: leading - current - trailing
    // Thêm mảng vào trước current (leading) => cập nhật message cuối cùng của leading
    // Thêm mảng vào sau current (trailing) => cập nhật message cuối cùng của current
    if (leadingMessageList != null) {
      final newMessages = _mapMessagesToUIModels(leadingMessageList);
      updatedMessages = [...newMessages, ...updatedMessages];
      final lastLeadingMessageIndex = newMessages.length - 1;
      updatedMessages = _updateUIModel(
        updatedMessages,
        lastLeadingMessageIndex,
      );
    }

    if (trailingMessageList != null) {
      final newMessages = _mapMessagesToUIModels(trailingMessageList);
      updatedMessages = [...updatedMessages, ...newMessages];
      final lastCurrentMessageIndex =
          updatedMessages.length - newMessages.length - 1;
      updatedMessages = _updateUIModel(
        updatedMessages,
        lastCurrentMessageIndex,
      );
    }

    return updatedMessages;
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _tagQuerySubscription?.cancel();
    _showTagOverlaySubscription?.cancel();
    _textEditingController.removeListener(_onTextChanged);
    return super.close();
  }
}
