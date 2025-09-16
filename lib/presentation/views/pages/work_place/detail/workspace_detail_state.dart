part of 'workspace_detail_bloc.dart';

class WSDetailState extends BaseState<WSDetailState> {
  const WSDetailState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.isInitialized = false,
    this.chatMessages = const [],
    this.pinnedMessageSummary,
    this.messageReply,
    this.scrollToBottom = false,
    this.showScrollToBottomIcon = false,
    this.hasOptions = true,
    this.hasSendButton = false,
    this.users = const [],
    this.chatMessagesPagingStatus = PagingStatus.idle,
    this.jumpToMessageIndex,
    this.scrollToTop = false,
    this.showTimeMessageId,
    this.initIndex = 0,
    this.isPinStatusSuccess = false,
    this.showTagOverlay = false,
  });

  final bool isInitialized;
  final List<ChatMessageUIModel> chatMessages;
  final PinnedMessageSummaryUiModel? pinnedMessageSummary;
  final MessageEntity? messageReply;
  final bool scrollToBottom;
  final bool showScrollToBottomIcon;
  final bool hasOptions;
  final bool hasSendButton;
  final List<UserEntity> users;
  final PagingStatus chatMessagesPagingStatus;
  final int? jumpToMessageIndex;
  final bool scrollToTop;
  final String? showTimeMessageId;
  final int initIndex;
  final bool isPinStatusSuccess;
  final bool showTagOverlay;

  bool get needLoadMoreOldMessages =>
      chatMessagesPagingStatus != PagingStatus.empty &&
      chatMessagesPagingStatus != PagingStatus.noMoreData;

  @override
  WSDetailState copyWith({
    bool? isInitialized,
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    List<ChatMessageUIModel>? chatMessages,
    PinnedMessageSummaryUiModel? pinnedMessageSummary,
    MessageEntity? messageReply,
    bool forceCloseReplyMessage = false,
    bool? scrollToBottom,
    bool? showScrollToBottomIcon,
    bool? hasOptions,
    bool? hasSendButton,
    List<UserEntity>? users,
    PagingStatus? chatMessagesPagingStatus,
    bool? hasMoreOldMessages,
    int? jumpToMessageIndex,
    bool? scrollToTop,
    bool forceCloseJumpToMessage = false,
    String? showTimeMessageId,
    bool forceDisableShowTime = false,
    int? initIndex,
    bool? isPinStatusSuccess,
    bool? showTagOverlay,
  }) {
    return WSDetailState(
      isInitialized: isInitialized ?? this.isInitialized,
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      chatMessages: chatMessages ?? this.chatMessages,
      pinnedMessageSummary: pinnedMessageSummary ?? this.pinnedMessageSummary,
      messageReply: forceCloseReplyMessage
          ? null
          : messageReply ?? this.messageReply,
      scrollToBottom: scrollToBottom ?? this.scrollToBottom,
      showScrollToBottomIcon:
          showScrollToBottomIcon ?? this.showScrollToBottomIcon,
      hasOptions: hasOptions ?? this.hasOptions,
      hasSendButton: hasSendButton ?? this.hasSendButton,
      users: users ?? this.users,
      chatMessagesPagingStatus:
          chatMessagesPagingStatus ?? this.chatMessagesPagingStatus,
      jumpToMessageIndex: forceCloseJumpToMessage
          ? null
          : jumpToMessageIndex ?? this.jumpToMessageIndex,
      scrollToTop: scrollToTop ?? this.scrollToTop,
      showTimeMessageId: forceDisableShowTime
          ? null
          : showTimeMessageId ?? this.showTimeMessageId,
      initIndex: initIndex ?? this.initIndex,
      isPinStatusSuccess: isPinStatusSuccess ?? this.isPinStatusSuccess,
      showTagOverlay: showTagOverlay ?? this.showTagOverlay,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    isInitialized,
    chatMessages,
    pinnedMessageSummary,
    messageReply,
    scrollToBottom,
    showScrollToBottomIcon,
    hasOptions,
    hasSendButton,
    users,
    chatMessagesPagingStatus,
    jumpToMessageIndex,
    scrollToTop,
    showTimeMessageId,
    initIndex,
    isPinStatusSuccess,
    showTagOverlay,
  ];
}
