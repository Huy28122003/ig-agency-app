import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/user/profile_info_entity.dart';
import 'package:ig_agency_app/domain/usecases/get_profile_info_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/cache/ram_cache.dart';
import '../../../../../dependencies/media/media_manager.dart';
import '../../../../../dependencies/file/file_manager.dart';
import '../../../../../domain/entities/message/message.dart';
import '../../../../../domain/entities/user.dart';
import '../../../../../domain/enums/message_enums.dart';
import '../../../../../domain/entities/user_entity.dart';
import '../../../../../domain/enums/send_message_type.dart';
import '../../../../../domain/usecases/member/fetch_member_in_group_use_case.dart';
import '../../../../../domain/usecases/message/get_pinned_message_summary_group_use_case.dart';
import '../../../../../domain/usecases/message/fetch_messages_in_group_use_case.dart';
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
  WSDetailBloc(
    this._getProfileInfoUseCase,
    this._fetchMessageUseCase,
    this._getPinnedMessageSummaryGroupUseCase,
    this._sendMessageUseCase,
    this._fetchMemberInGroupUseCase,
    this._searchMemberInGroupUseCase,
    this._unpinMessageUseCase,
    this._pinMessageUseCase,
    this._deleteMessageForEveryoneUseCase,
    this._deleteMessageForYouUseCase,
    this._ramCache,
    this._mediaManager,
    this._fileManager,
    this._deleteConversationUseCase,
  ) : super(WSDetailState()) {
    _registerHandlers();
    _initializeListener();

    // TODO hoannk: Remove this after testing, fake user removed event
    Future.delayed(const Duration(seconds: 3), () {
      if (!isClosed) {
        add(
          AddMessageEvent(
            message: MessageEntity(
              id: 'msg_${groupId}_${DateTime.now().millisecondsSinceEpoch}',
              groupId: groupId,
              user: UserSummary(id: '1', name: 'Admin', avatar: ''),
              createdAt: DateTime.now(),
              content: SystemMessageContent(
                systemType: SystemMessageType.userRemoved,
                message: 'Admin removed you from the group.',
              ),
              status: MessageStatus.sent,
            ),
          ),
        );
      }
    });
  }

  late final int groupId;
  final GetProfileInfoUseCase _getProfileInfoUseCase;
  final FetchMessagesInGroupUseCase _fetchMessageUseCase;
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

  final int _limit = 20;
  final TagUserTextEditingController _textEditingController =
      TagUserTextEditingController();

  String? get userId => state.profile?.id;

  TagUserTextEditingController get textEditingController =>
      _textEditingController;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<LoadMoreChatMessagesEvent>(
      _onLoadMoreMessages,
      // bỏ qua bất kỳ sự kiện nào được thêm vào trong khi sự kiện đang được xử lý
      transformer: droppable(),
    );
    handleSubEvent<JumpToMessageEvent>(
      _onJumpToMessage,
      // chỉ xử lý sự kiện mới nhất và hủy bỏ trình xử lý sự kiện trước đó
      transformer: restartable(),
    );
    handleSubEvent<CloseReplyMessageEvent>(_onCloseReplyMessage);
    handleSubEvent<ReplyToMessageEvent>(_onReplyToMessage);
    handleSubEvent<ToggleShowScrollToBottomIcon>(
      _onToggleShowScrollToBottomIcon,
    );
    handleSubEvent<ResetScrollToBottomEvent>(_onResetScrollToBottom);
    handleSubEvent<SendMessageEvent>(_onSendMessage);
    handleSubEvent<AddMessageEvent>(
      _onAddMessage,
      // xử lý các sự kiện theo trình tự
      transformer: sequential(),
    );
    handleSubEvent<ToggleHasOptionsEvent>(_onToggleHasOptions);
    handleSubEvent<ToggleHasSendButtonEvent>(_onToggleHasSendButton);
    handleSubEvent<ToggleShowTagOverlayEvent>(_onToggleShowTagOverlay);
    handleSubEvent<SearchMembersEvent>(_onSearchMembers);
    handleSubEvent<ToggleShowTimeEvent>(_onShowTime);
    handleSubEvent<GetPinnedMessageSummaryEvent>(_onGetPinnedMessageSummary);

    handleSubEvent<TogglePinMessageFromDetailEvent>(
      _onTogglePinMessageFromDetail,
    );
    handleSubEvent<DeleteMessageForEveryoneEvent>(_onDeleteMessageForEveryone);
    handleSubEvent<DeleteMessageForYouEvent>(_onDeleteMessageForYou);
    handleSubEvent<DeleteConversationEvent>(_onDeleteConversation);
  }

  void _initializeListener() {
    // Listen to message stream
    _messageSubscription = _ramCache.getMessageStream().listen(
      (message) {
        if (message.groupId != groupId) return;
        add(AddMessageEvent(message: message));
      },
      onError: (_) {
        // TODO hoank: Handle this case.
      },
    );

    // Listen to text editing controller streams
    _showTagOverlaySubscription = _textEditingController.showTagOverlay.listen((
      show,
    ) {
      add(ToggleShowTagOverlayEvent(showTagOverlay: show));
    });

    _tagQuerySubscription = _textEditingController.tagQuery.listen((query) {
      add(SearchMembersEvent(query: query));
    });

    // Listen to text changes for send button
    _textEditingController.addListener(_onTextChanged);
  }

  Timer? _sendButtonDebounceTimer;

  void _onTextChanged() {
    final input = _textEditingController.text;

    _sendButtonDebounceTimer?.cancel();
    // Debounce prevent change send button state when text edit controller executing
    _sendButtonDebounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (state.showSendButton && input.isEmpty) {
        add(ToggleHasSendButtonEvent(showSendButton: false));
      } else if (!state.showSendButton && input.isNotEmpty) {
        add(ToggleHasSendButtonEvent(showSendButton: true));
      }
    });
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final profile = await _getProfileInfoUseCase.call();

    final messagesResult = await _fetchMessageUseCase.call(
      FetchMessagesInGroupParams(groupId: groupId, limit: _limit),
    );

    final messages = messagesResult;
    final pagingStatus = messages.isEmpty
        ? PagingStatus.empty
        : (messages.length < _limit
              ? PagingStatus.noMoreData
              : PagingStatus.loadCompleted);

    final pinnedMessageSummaryResult =
        await _getPinnedMessageSummaryGroupUseCase.call(
          GetPinnedMessageSummaryGroupParams(groupId: groupId),
        );

    final pinnedMessageSummary = pinnedMessageSummaryResult.toUIModel();

    final users = await _fetchMemberInGroupUseCase.call(
      FetchMemberInGroupParams(groupId: groupId),
    );

    emit(
      state.copyWith(
        profile: profile,
        pageStatus: PageStatus.loaded,
        chatMessages: messages.isEmpty ? [] : _mapMessagesToUIModels(messages),
        pagingStatus: pagingStatus,
        pinnedMessageSummary: pinnedMessageSummary,
        initIndex: messages.isEmpty ? 0 : messages.length - 1,
        users: users,
        usersSearch: users,
      ),
    );
  }

  Future<void> _onLoadMoreMessages(
    LoadMoreChatMessagesEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    if (state.pagingStatus == PagingStatus.noMoreData ||
        state.pagingStatus == PagingStatus.empty) {
      return;
    }

    emit(state.copyWith(pagingStatus: PagingStatus.loading));

    final messages = await _fetchMessageUseCase.call(
      FetchMessagesInGroupParams(
        groupId: groupId,
        limit: _limit,
        oldestMessageId: state.chatMessages.first.message.id,
      ),
    );

    // TODO hoannk: Remove delay
    await Future.delayed(const Duration(seconds: 2));

    if (messages.isEmpty || messages.length < _limit) {
      return emit(state.copyWith(pagingStatus: PagingStatus.noMoreData));
    }

    final updatedMessages = _addMessageList(leadingMessageList: messages);

    emit(
      state.copyWith(
        chatMessages: updatedMessages,
        pagingStatus: PagingStatus.loadCompleted,
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
    final userId = this.userId;
    if (userId == null) return;
    final reply = state.messageReply;

    add(CloseReplyMessageEvent());

    dynamic content;
    if (event.type == SendMessageType.text) {
      // final text = _textEditingController.text;
      // final tagTextSegments = _textEditingController.tagTextSegments;
      // final linkTextSegments = detectLinkTextSegment(text);
      // final textSegments = [...tagTextSegments, ...linkTextSegments];
      // content = TextMessageContent(text: text, textSegments: textSegments);

      // TODO: Demo search
      final text =
          '''Hôm nay @minh đi dạo quanh Hồ Gươm cùng @anh và @minhchoco. 
Cậu ấy bảo: “Tôi cho bạn xem link này: https://flutter.dev và https://dart.dev 
rất hay, mình cho thêm ví dụ trong https://example.com/cho.” 
Chúng mình ăn chocolate, trò chuyện về việc cho trẻ em học lập trình. 
Đặc biệt, mình cho đi nhiều kinh nghiệm quý giá, cho tới tận khuya mới về. 
''';

      final textSegments = [
        TextSegment(type: TextSegmentType.tag, start: 8, end: 13), // @minh
        TextSegment(type: TextSegmentType.tag, start: 40, end: 44), // @anh
        TextSegment(
          type: TextSegmentType.tag,
          start: 48,
          end: 58,
        ), // @minhchoco
        TextSegment(
          type: TextSegmentType.link,
          start: 100,
          end: 119,
        ), // https://flutter.dev
        TextSegment(
          type: TextSegmentType.link,
          start: 123,
          end: 139,
        ), // https://dart.dev
        TextSegment(
          type: TextSegmentType.link,
          start: 176,
          end: 199,
        ), // https://example.com/cho
      ];

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
        groupId: groupId,
        replyMessageId: reply?.id,
        content: content,
      ),
    );
  }

  Future<void> _onResetScrollToBottom(
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
    final messageContent = message.content;

    if (messageContent is SystemMessageContent) {
      final systemMessageContent = messageContent;
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

    emit(
      state.copyWith(
        chatMessages: updatedListUiModel,
        scrollToBottom: message.user.id == userId,
      ),
    );
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
      emit(state.copyWith(usersSearch: []));
      return;
    }
    final users = await _searchMemberInGroupUseCase.call(
      SearchMemberInGroupParams(groupId: groupId, query: event.query),
    );
    emit(state.copyWith(usersSearch: users));
  }

  Future<void> _onJumpToMessage(
    JumpToMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final messageId = event.messageId;
    final hasMessage = state.chatMessages.any(
      (uiModel) => uiModel.message.id == event.messageId,
    );

    if (!hasMessage &&
        (state.pagingStatus != PagingStatus.noMoreData ||
            state.pagingStatus != PagingStatus.empty)) {
      emit(state.copyWith(pagingStatus: PagingStatus.loading));

      final result = await _fetchMessageUseCase.call(
        FetchMessagesInGroupParams(
          groupId: groupId,
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

      final hasMessage = updatedMessages.any(
        (uiModel) => uiModel.message.id == event.messageId,
      );

      if (hasMessage) {
        emit(
          state.copyWith(
            chatMessages: updatedMessages,
            pagingStatus: pagingStatus,
            jumpToMessageId: messageId,
          ),
        );
      } else {
        emit(
          state.copyWith(
            chatMessages: updatedMessages,
            pagingStatus: pagingStatus,
          ),
        );
      }
    } else if (hasMessage) {
      emit(state.copyWith(jumpToMessageId: messageId));
    }
  }

  Future<void> _onShowTime(
    ToggleShowTimeEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final uiModelIndex = state.chatMessages.indexWhere(
      (uiModel) => uiModel.message.id == event.messageId,
    );
    if (uiModelIndex < 0) return;
    final uiModel = state.chatMessages[uiModelIndex];
    if (uiModel.message.content.isText && !uiModel.showTime) {
      if (!uiModel.shouldShowTime) {
        final updatedMessages = _updateUIModel(
          state.chatMessages,
          uiModelIndex,
          forceShowTime: true,
        );
        emit(
          state.copyWith(
            chatMessages: updatedMessages,
            showTimeMessageId: event.messageId,
          ),
        );
      } else if (uiModel.shouldShowTime) {
        final updatedMessages = _updateUIModel(
          state.chatMessages,
          uiModelIndex,
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

  Future<void> _onTogglePinMessageFromDetail(
    TogglePinMessageFromDetailEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(processing: true));
    final messages = List<ChatMessageUIModel>.from(state.chatMessages);

    final uiModelIndex = messages.indexWhere(
      (uiModel) => uiModel.message.id == event.messageId,
    );

    if (uiModelIndex >= 0) {
      emit(state.copyWith(processing: false));
      return;
    }

    final currentMessage = messages[uiModelIndex];

    final isPinned = currentMessage.message.isPinned;

    if (isPinned) {
      await _unpinMessageUseCase.call(
        UnpinMessageParams(messageId: event.messageId),
      );
    } else {
      await _pinMessageUseCase.call(
        PinMessageParams(messageId: event.messageId),
      );
    }

    add(GetPinnedMessageSummaryEvent());

    // TODO hoannk: Remove delay
    await Future.delayed(const Duration(seconds: 2));

    messages[uiModelIndex] = currentMessage.copyWith(
      message: currentMessage.message.copyWith(isPinned: !isPinned),
    );

    emit(state.copyWith(chatMessages: messages, processing: false));
  }

  Future<void> _onToggleShowTagOverlay(
    ToggleShowTagOverlayEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    // Reset lits when disable tag overlay
    if (!event.showTagOverlay) {
      emit(state.copyWith(usersSearch: state.users));
    }
    emit(state.copyWith(showTagOverlay: event.showTagOverlay));
  }

  Future<void> _onGetPinnedMessageSummary(
    GetPinnedMessageSummaryEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final pinnedMessageSummary = await _getPinnedMessageSummaryGroupUseCase
        .call(GetPinnedMessageSummaryGroupParams(groupId: groupId));

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
      DeleteConversationParams(groupId: groupId),
    );
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(processing: false, isDeletedConversationSuccess: true));
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
    final uiModelIndex = chatMessages.indexWhere(
      (uiModel) => uiModel.message.id == messageId,
    );
    var updatedMessages = List<ChatMessageUIModel>.from(chatMessages);
    if (uiModelIndex >= 0) {
      updatedMessages.removeAt(uiModelIndex);
      // Cập nhật message trước của message vừa xoá
      if (uiModelIndex > 0) {
        updatedMessages = _updateUIModel(updatedMessages, uiModelIndex - 1);
      }
      // Cập nhật message sau của message vừa xoá
      if (uiModelIndex < updatedMessages.length - 1) {
        updatedMessages = _updateUIModel(updatedMessages, uiModelIndex + 1);
      }
    }
    return updatedMessages;
  }

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

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _tagQuerySubscription?.cancel();
    _showTagOverlaySubscription?.cancel();
    _sendButtonDebounceTimer?.cancel();
    _textEditingController.removeListener(_onTextChanged);
    return super.close();
  }
}
