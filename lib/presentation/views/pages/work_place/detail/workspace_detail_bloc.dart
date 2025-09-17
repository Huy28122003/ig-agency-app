import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
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
import '../../../../../domain/usecases/member/fetch_member_in_group_use_case.dart';
import '../../../../../domain/usecases/message/get_pinned_message_summary_group_use_case.dart';
import '../../../../../domain/usecases/message/fetch_messages_workspace_use_case.dart';
import '../../../../../domain/usecases/message/send_message_use_case.dart';
import '../../../../../domain/usecases/message/unpin_message_use_case.dart';
import '../../../../../domain/usecases/message/pin_message_use_case.dart';
import '../../../../../domain/usecases/message/delete_message_for_everyone_use_case.dart';
import '../../../../../domain/usecases/message/delete_message_for_you_use_case.dart';
import '../../../../../domain/usecases/message/delete_conversation_use_case.dart';
import '../../../../../domain/usecases/member/search_member_in_group_use_case.dart';
import '../../../../../shared/commons/enums/group_chat_status.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../ui_models/chat_message/chat_message_ui_model_helper.dart';
import '../../../../../shared/utils/tag_user_text_editing_controller.dart';
import '../../../../base/base_state.dart';
import '../../../ui_models/pinned_message_summary_ui_model.dart';
import '../../../ui_models/chat_message/chat_message_ui_model.dart';

part 'workspace_detail_event.dart';

part 'workspace_detail_state.dart';

@injectable
class WSDetailBloc extends BaseBloc<WSDetailEvent, WSDetailState> {
  WSDetailBloc({
    required FetchMessagesWorkspaceUseCase fetchMessageUseCase,
    required GetPinnedMessageSummaryGroupUseCase
    getPinnedMessageSummaryGroupUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required FetchMemberInGroupUseCase fetchMemberInGroupUseCase,
    required SearchMemberInGroupUseCase searchMemberInGroupUseCase,
    required UnpinMessageUseCase unpinMessageUseCase,
    required PinMessageUseCase pinMessageUseCase,
    required DeleteMessageForEveryoneUseCase deleteMessageForEveryoneUseCase,
    required DeleteMessageForYouUseCase deleteMessageForYouUseCase,
    required RamCache ramCache,
    required MediaManager mediaManager,
    required FileManager fileManager,
    required DeleteConversationUseCase deleteConversationUseCase,
  }) : _fetchMessageUseCase = fetchMessageUseCase,
       _getPinnedMessageSummaryGroupUseCase =
           getPinnedMessageSummaryGroupUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _fetchMemberInGroupUseCase = fetchMemberInGroupUseCase,
       _searchMemberInGroupUseCase = searchMemberInGroupUseCase,
       _unpinMessageUseCase = unpinMessageUseCase,
       _pinMessageUseCase = pinMessageUseCase,
       _deleteMessageForEveryoneUseCase = deleteMessageForEveryoneUseCase,
       _deleteMessageForYouUseCase = deleteMessageForYouUseCase,
       _deleteConversationUseCase = deleteConversationUseCase,
       _ramCache = ramCache,
       _mediaManager = mediaManager,
       _fileManager = fileManager,
       super(WSDetailState()) {
    _registerHandlers();
    _initializeListener();

    // TODO hoannk: Remove this after testing, fake user removed event
    Future.delayed(const Duration(seconds: 60), () {
      add(
        AddMessageEvent(
          message: MessageEntity(
            id: 'msg_${workspaceId}_${DateTime.now().millisecondsSinceEpoch}',
            workspaceId: workspaceId,
            sender: MessageSender.system,
            createdAt: DateTime.now(),
            type: MessageType.system,
            content: MessageContent.system(
              systemType: SystemMessageType.userRemoved,
              message: 'Admin removed you from the group.',
            ),
            status: MessageStatus.sent,
          ),
        ),
      );
    });
  }

  late final int workspaceId;
  final FetchMessagesWorkspaceUseCase _fetchMessageUseCase;
  final GetPinnedMessageSummaryGroupUseCase
  _getPinnedMessageSummaryGroupUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final FetchMemberInGroupUseCase _fetchMemberInGroupUseCase;
  final SearchMemberInGroupUseCase _searchMemberInGroupUseCase;
  final UnpinMessageUseCase _unpinMessageUseCase;
  final PinMessageUseCase _pinMessageUseCase;
  final DeleteMessageForEveryoneUseCase _deleteMessageForEveryoneUseCase;
  final DeleteMessageForYouUseCase _deleteMessageForYouUseCase;
  final DeleteConversationUseCase _deleteConversationUseCase;

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
    handleSubEvent<ToggleHasOptionsEvent>(_onToggleHasOptions);
    handleSubEvent<ToggleHasSendButtonEvent>(_onToggleHasSendButton);
    handleSubEvent<SearchMembersEvent>(_onSearchMembers);
    handleSubEvent<JumpToMessageEvent>(_onJumpToMessage);
    handleSubEvent<ResetJumpToMessageEvent>(_onResetJumpToMessage);
    handleSubEvent<ToggleShowTimeEvent>(_onShowTime);
    handleSubEvent<GetPinnedMessageSummaryEvent>(_onGetPinnedMessageSummary);
    handleSubEvent<LoadMoreChatMessagesEvent>(
      _onLoadMoreMessages,
      // droppable to ensure that only one load more request is processed at a time
      transformer: droppable(),
    );
    handleSubEvent<TogglePinMessageFromDetailEvent>(_onPinMessage);
    handleSubEvent<ResetPinStatusSuccessEvent>(_onResetPinStatusSuccess);
    handleSubEvent<UpdateShowTagOverlayEvent>(_onUpdateShowTagOverlay);
    handleSubEvent<DeleteMessageForEveryoneEvent>(_onDeleteMessageForEveryone);
    handleSubEvent<DeleteMessageForYouEvent>(_onDeleteMessageForYou);
    handleSubEvent<DeleteConversationEvent>(_onDeleteConversation);
    handleSubEvent<ToggleOptionsEvent>(_onToggleOptions);
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

    if (state.showSendButton && input.isEmpty) {
      add(ToggleHasSendButtonEvent(showSendButton: false));
    } else if (!state.showSendButton && input.isNotEmpty) {
      add(ToggleHasSendButtonEvent(showSendButton: true));
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

    final messages = result;
    final pagingStatus = messages.isEmpty
        ? PagingStatus.empty
        : (messages.length < _limit
              ? PagingStatus.noMoreData
              : PagingStatus.loadCompleted);

    final pinnedMessageSummaryResult =
        await _getPinnedMessageSummaryGroupUseCase.call(
          GetPinnedMessageSummaryGroupParams(workspaceId: workspaceId),
        );

    final pinnedMessageSummary = pinnedMessageSummaryResult.toUIModel();

    final users = await _fetchMemberInGroupUseCase.call(
      FetchMemberInGroupParams(workspaceId: workspaceId),
    );

    emit(
      state.copyWith(
        isInitialized: true,
        pageStatus: PageStatus.loaded,
        chatMessages: messages.isEmpty ? [] : _mapMessagesToUIModels(messages),
        chatMessagesPagingStatus: pagingStatus,
        pinnedMessageSummary: pinnedMessageSummary,
        initIndex: messages.isEmpty ? 0 : messages.length - 1,
        users: users,
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

    final messages = result;
    final pagingStatus = messages.isEmpty || messages.length < _limit
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
      final text = _textEditingController.text;
      final tagTextSegments = _textEditingController.tagTextSegments;
      final linkTextSegments = detectLinkTextSegment(text);
      final textSegments = [...tagTextSegments, ...linkTextSegments];
      content = TextMessageContent(text: text, textSegments: textSegments);
      // Clear text editing controller
      _textEditingController.clear();
    } else if (event.type == SendMessageType.file) {
      final result = await _fileManager.pickFile();
      if (result == null) return;
      final file = result;

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
    emit(state.copyWith(scrollToBottom: false, showScrollToBottomIcon: false));
  }

  Future<void> _onAddMessage(
    AddMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final message = event.message;

    if (message.type == MessageType.system &&
        message.content is SystemMessageContent) {
      final systemMessageContent = message.content as SystemMessageContent;
      if (systemMessageContent.systemType == SystemMessageType.userRemoved) {
        emit(
          state.copyWith(
            groupMemberStatus: GroupMemberStatus.removed,
            chatMessages: _mapMessagesToUIModels([message]),
          ),
        );
        return;
      }
    }

    final uiModel = message.toUIModel(
      previousMessage: state.chatMessages.isNotEmpty
          ? state.chatMessages.last.message
          : null,
    );
    final chatMessages = [...state.chatMessages, uiModel];
    final messageIndex = chatMessages.length - 1;
    final updatedListUiModel = _updateUIModel(chatMessages, messageIndex);

    emit(state.copyWith(chatMessages: updatedListUiModel));
  }

  Future<void> _onToggleHasOptions(
    ToggleHasOptionsEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(showOptions: event.showOptions));
  }

  Future<void> _onToggleHasSendButton(
    ToggleHasSendButtonEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(showSendButton: event.showSendButton));
  }

  Future<void> _onSearchMembers(
    SearchMembersEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(users: []));
      return;
    }
    final users = await _searchMemberInGroupUseCase.call(
      SearchMemberInGroupParams(workspaceId: workspaceId, query: event.query),
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

      final messages = result;
      final pagingStatus = messages.isEmpty || messages.length < _limit
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
    ToggleShowTimeEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final messageIndex = state.chatMessages.indexWhere(
      (uiModel) => uiModel.message.id == event.messageId,
    );
    if (messageIndex == -1) return;
    final message = state.chatMessages[messageIndex];

    if (message.message.type == MessageType.text && !message.showTime) {
      if (!message.shouldShowTime) {
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
      } else if (message.shouldShowTime) {
        final updatedMessages = _updateUIModel(
          state.chatMessages,
          messageIndex,
          forceShowTime: false,
        );
        emit(
          state.copyWith(
            chatMessages: updatedMessages,
            forceDisableShowTime: true,
          ),
        );
      }
    }
  }

  Future<void> _onResetPinStatusSuccess(
    ResetPinStatusSuccessEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(isPinStatusSuccess: false));
  }

  Future<void> _onPinMessage(
    TogglePinMessageFromDetailEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(processing: true));
    final messageIndex = state.chatMessages.indexWhere(
      (uiModel) => uiModel.message.id == event.messageId,
    );
    if (messageIndex == -1) return;

    if (state.chatMessages[messageIndex].message.isPinned) {
      await _unpinMessageUseCase.call(
        UnpinMessageParams(messageId: event.messageId),
      );
    } else {
      await _pinMessageUseCase.call(
        PinMessageParams(messageId: event.messageId),
      );
    }
    // TODO hoannk: Remove delay
    await Future.delayed(const Duration(seconds: 2));

    final messages = List<ChatMessageUIModel>.from(state.chatMessages);
    final currentMessage = messages[messageIndex];
    messages[messageIndex] = currentMessage.copyWith(
      message: currentMessage.message.copyWith(
        isPinned: !currentMessage.message.isPinned,
      ),
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
    final pinnedMessageSummary = await _getPinnedMessageSummaryGroupUseCase
        .call(GetPinnedMessageSummaryGroupParams(workspaceId: workspaceId));

    final uiModel = pinnedMessageSummary.toUIModel();

    emit(state.copyWith(pinnedMessageSummary: uiModel));
  }

  Future<void> _onDeleteMessageForEveryone(
    DeleteMessageForEveryoneEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    try {
      await _deleteMessageForEveryoneUseCase.call(
        DeleteMessageForEveryoneParams(messageId: event.messageId),
      );

      await Future.delayed(const Duration(seconds: 2));

      final updatedMessages = _deleteMessage(
        state.chatMessages,
        event.messageId,
      );

      emit(state.copyWith(chatMessages: updatedMessages, processing: false));
    } catch (e) {
      emit(state.copyWith(processing: false));
    }
  }

  Future<void> _onDeleteMessageForYou(
    DeleteMessageForYouEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    try {
      await _deleteMessageForYouUseCase.call(
        DeleteMessageForYouParams(messageId: event.messageId),
      );

      await Future.delayed(const Duration(seconds: 2));

      final updatedMessages = _deleteMessage(
        state.chatMessages,
        event.messageId,
      );

      emit(state.copyWith(chatMessages: updatedMessages, processing: false));
    } catch (e) {
      emit(state.copyWith(processing: false));
    }
  }

  Future<void> _onDeleteConversation(
    DeleteConversationEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(processing: true));
    await _deleteConversationUseCase.call(
      DeleteConversationParams(workspaceId: workspaceId),
    );
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(processing: false, isDeletedConversationSuccess: true));
  }

  Future<void> _onToggleOptions(
    ToggleOptionsEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(showOptions: event.showOptions));
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
    // với mỗi previous message và next message, cần check lại cả previous của
    // previous message, next message cần check lại cả next của next message

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
        ) = ChatMessageUiModelHelper.updateUIModel(
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
        ) = ChatMessageUiModelHelper.updateUIModel(
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

  List<ChatMessageUIModel> _deleteMessage(
    List<ChatMessageUIModel> chatMessages,
    String messageId,
  ) {
    final messageIndex = chatMessages.indexWhere(
      (uiModel) => uiModel.message.id == messageId,
    );
    var updatedMessages = List<ChatMessageUIModel>.from(chatMessages);
    if (messageIndex != -1) {
      updatedMessages.removeAt(messageIndex);
      // Cập nhật message trước của message vừa xoá
      if (messageIndex > 0) {
        updatedMessages = _updateUIModel(updatedMessages, messageIndex - 1);
      }
      // Cập nhật message sau của message vừa xoá
      if (messageIndex < updatedMessages.length - 1) {
        updatedMessages = _updateUIModel(updatedMessages, messageIndex + 1);
      }
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
