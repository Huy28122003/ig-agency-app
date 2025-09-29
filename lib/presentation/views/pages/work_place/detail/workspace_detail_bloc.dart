import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/user/profile_info_entity.dart';
import 'package:ig_agency_app/domain/usecases/get_profile_info_use_case.dart';
import 'package:ig_agency_app/domain/usecases/message/search_message_in_group_use_case.dart';
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
    this._searchMessageInGroupUseCase,
  ) : super(WSDetailState()) {
    _registerHandlers();
    _initializeListener();
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
  final SearchMessageInGroupUseCase _searchMessageInGroupUseCase;

  final MediaManager _mediaManager;
  final FileManager _fileManager;
  final RamCache _ramCache;
  Timer? _timer;

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
    handleSubEvent<CancelSearchEvent>(_onCancelSearch);
    handleSubEvent<SearchMessageEvent>(_onSearchMessage);
    handleSubEvent<SearchMessageDebouncedEvent>(_onSearchMessageDebounced);
    handleSubEvent<SearchKeywordChangeEvent>(_onSearchKeywordChange);
    handleSubEvent<GoToMessageEvent>(_onGoToMessage);
    handleSubEvent<OnShowGroupInfoEvent>(_onShowGroupInfo);
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

    final messages = messagesResult.reversed.toList();
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
        users: users,
        usersSearch: users,
        isSearchMode: event.isSearchMode,
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

    final messagesResult = await _fetchMessageUseCase.call(
      FetchMessagesInGroupParams(
        groupId: groupId,
        limit: _limit,
        oldestMessageId: state.chatMessages.last.message.id,
      ),
    );

    // TODO hoannk: Remove delay
    await Future.delayed(const Duration(seconds: 2));

    final messages = messagesResult.reversed.toList();

    if (messages.isEmpty) {
      return emit(state.copyWith(pagingStatus: PagingStatus.noMoreData));
    }

    final updatedMessages = _addMessageList(leadingMessageList: messages);

    emit(
      state.copyWith(
        chatMessages: updatedMessages,
        pagingStatus: messages.length < _limit
            ? PagingStatus.noMoreData
            : PagingStatus.loadCompleted,
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
          ? state.chatMessages.first.message
          : null,
    );
    final chatMessages = [uiModel, ...state.chatMessages];
    final messageIndex = 0;
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

      final messagesResult = await _fetchMessageUseCase.call(
        FetchMessagesInGroupParams(
          groupId: groupId,
          limit: _limit,
          oldestMessageId: state.chatMessages.first.message.id,
          targetMessageId: event.messageId,
        ),
      );

      // TODO hoannk: Remove delay
      await Future.delayed(const Duration(seconds: 2));

      final messages = messagesResult.reversed.toList();

      if (messages.isEmpty) {
        return emit(state.copyWith(pagingStatus: PagingStatus.noMoreData));
      }

      final pagingStatus = messages.length < _limit
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
    var messages = state.chatMessages;

    final messageIndex = messages.indexWhere(
      (uiModel) => uiModel.message.id == event.messageId,
    );
    if (messageIndex < 0) return;
    final message = messages[messageIndex];

    // Check message hiện tại với showTimeMessage trong state có trùng nhau không
    // Nếu không trùng thực hiện việc cập nhật lại khi lúc không show time
    final showTimeMessage = state.showTimeMessage;
    if (showTimeMessage != null &&
        showTimeMessage.message.id != event.messageId) {
      final showTimeMessageIndex = messages.indexWhere(
        (uiModel) => uiModel.message.id == showTimeMessage.message.id,
      );
      if (showTimeMessageIndex >= 0) {
        messages = _updateUIModel(
          messages,
          showTimeMessageIndex,
          forceShowTime: false,
        );
      }
    }

    if (message.message.content.isText && !message.showTime) {
      if (!message.shouldShowTime) {
        final updatedMessages = _updateUIModel(
          messages,
          messageIndex,
          forceShowTime: true,
        );
        emit(
          state.copyWith(
            chatMessages: updatedMessages,
            showTimeMessage: message,
          ),
        );
      } else if (message.shouldShowTime) {
        final updatedMessages = _updateUIModel(
          messages,
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
        // reverse, previous = i+1 (mới hơn), next = i-1 (cũ hơn)
        previousMessage: i < messages.length - 1 ? messages[i + 1] : null,
        nextMessage: i > 0 ? messages[i - 1] : null,
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
    var currentMessage = chatMessages[messageIndex];
    final showTime = forceShowTime;
    if (showTime != null) {
      if (showTime) {
        currentMessage = currentMessage.copyWith(
          shouldShowTime: true,
          shouldShowAvatar: true,
          shouldShowUserName: true,
          isContinuation: false,
        );
      } else {
        // Check nếu trùng id với showTimeMessage trong state thì cập nhật lại vào currentMessage
        final showTimeMessage = state.showTimeMessage;
        if (showTimeMessage != null &&
            showTimeMessage.message.id == currentMessage.message.id) {
          currentMessage = currentMessage.copyWith(
            shouldShowTime: showTimeMessage.shouldShowTime,
            shouldShowAvatar: showTimeMessage.shouldShowAvatar,
            shouldShowUserName: showTimeMessage.shouldShowUserName,
            isContinuation: showTimeMessage.isContinuation,
          );
        }
      }
    }
    updatedMessages[messageIndex] = currentMessage;

    // reverse: previous = mới hơn, next = cũ hơn
    final previousMessage = messageIndex < updatedMessages.length - 1
        ? updatedMessages[messageIndex + 1]
        : null;
    final nextMessage = messageIndex > 0
        ? updatedMessages[messageIndex - 1]
        : null;

    if (previousMessage != null) {
      final previousPreviousMessage = messageIndex < updatedMessages.length - 2
          ? updatedMessages[messageIndex + 2]
          : null;
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
      updatedMessages[messageIndex + 1] = previousMessage.copyWith(
        shouldShowTime: shouldShowTime,
        shouldShowAvatar: shouldShowAvatar,
        shouldShowUserName: shouldShowUserName,
        isContinuation: isContinuation,
      );
    }

    if (nextMessage != null) {
      final nextNextMessage = messageIndex > 1
          ? updatedMessages[messageIndex - 2]
          : null;
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
      updatedMessages[messageIndex - 1] = nextMessage.copyWith(
        shouldShowTime: shouldShowTime,
        shouldShowAvatar: shouldShowAvatar,
        shouldShowUserName: shouldShowUserName,
        isContinuation: isContinuation,
      );
    }

    return updatedMessages;
  }

  List<ChatMessageUIModel> _addMessageList({
    List<MessageEntity>? leadingMessageList,
    List<MessageEntity>? trailingMessageList,
  }) {
    var updatedMessages = List<ChatMessageUIModel>.from(state.chatMessages);

    if (leadingMessageList != null && leadingMessageList.isNotEmpty) {
      final newMessages = _mapMessagesToUIModels(leadingMessageList);
      // nối vào sau
      updatedMessages = [...updatedMessages, ...newMessages];
      final firstLeadingIndex = updatedMessages.length - newMessages.length;
      updatedMessages = _updateUIModel(updatedMessages, firstLeadingIndex);
    }

    if (trailingMessageList != null) {
      final newMessages = _mapMessagesToUIModels(trailingMessageList);
      // nối vào trước
      updatedMessages = [...newMessages, ...updatedMessages];
      final firstTrailingIndex = newMessages.length - 1;
      updatedMessages = _updateUIModel(updatedMessages, firstTrailingIndex);
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
    if (messageIndex >= 0) {
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

  Future<void> _onCancelSearch(
    CancelSearchEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        isSearchMode: false,
        indexSearchMessage: 0,
        messageSearchResults: const [],
      ),
    );
  }

  Future<void> _onSearchMessage(
    SearchMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1000), () async {
      add(SearchMessageDebouncedEvent(value: state.searchKeyword));
    });
  }

  Future<void> _onSearchMessageDebounced(
    SearchMessageDebouncedEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(messageSearchResults: const [], indexSearchMessage: 0));
    final result = await _searchMessageInGroupUseCase.call(
      SearchMessageInGroupParams(
        workspaceId: groupId,
        searchMessage: event.value,
      ),
    );
    emit(state.copyWith(indexSearchMessage: 0, messageSearchResults: result));
  }

  Future<void> _onSearchKeywordChange(
    SearchKeywordChangeEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(searchKeyword: event.value));
  }

  Future<void> _onGoToMessage(
    GoToMessageEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    final index = event.isGoUp
        ? state.indexSearchMessage + 1
        : state.indexSearchMessage - 1;
    final messageId = state.messageSearchResults[index].id;
    add(JumpToMessageEvent(messageId: messageId));
    emit(state.copyWith(indexSearchMessage: index));
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

  Future<void> _onShowGroupInfo(
    OnShowGroupInfoEvent event,
    Emitter<WSDetailState> emit,
  ) async {
    emit(state.copyWith(showGroupInfo: !state.showGroupInfo));
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
