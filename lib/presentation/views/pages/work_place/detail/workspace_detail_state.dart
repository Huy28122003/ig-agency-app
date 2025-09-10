part of 'workspace_detail_bloc.dart';

class WSDetailState extends BaseState<WSDetailState> {
  const WSDetailState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.chatMessages = const [],
    this.pinnedMessageSummary,
    this.messageReply,
    this.scrollToBottom = false,
    this.showScrollToBottomIcon = false,
    this.hasOptions = true,
    this.hasSendButton = false,
    this.users = const [],
    this.isUnpinSuccess = false,
    this.pinnedMessages = const [],
    this.pinnedMessagesPagingStatus = PagingStatus.idle,
    this.jumpToMessageIndex,
    this.showTimeMessageId,
  });

  final List<ChatMessageUIModel> chatMessages;
  final PinnedMessageSummaryUiModel? pinnedMessageSummary;
  final MessageEntity? messageReply;
  final bool scrollToBottom;
  final bool showScrollToBottomIcon;
  final bool hasOptions;
  final bool hasSendButton;
  final List<UserEntity> users;
  final bool isUnpinSuccess;
  final List<PinnedMessageUIModel> pinnedMessages;
  final PagingStatus pinnedMessagesPagingStatus;
  final int? jumpToMessageIndex;
  final String? showTimeMessageId;

  @override
  WSDetailState copyWith({
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
    bool? isUnpinSuccess,
    List<PinnedMessageUIModel>? pinnedMessages,
    PagingStatus? pinnedMessagesPagingStatus,
    int? jumpToMessageIndex,
    bool forceCloseJumpToMessage = false,
    String? showTimeMessageId,
    bool forceDisableShowTime = false,
  }) {
    return WSDetailState(
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
      isUnpinSuccess: isUnpinSuccess ?? this.isUnpinSuccess,
      pinnedMessages: pinnedMessages ?? this.pinnedMessages,
      pinnedMessagesPagingStatus:
          pinnedMessagesPagingStatus ?? this.pinnedMessagesPagingStatus,
      jumpToMessageIndex: forceCloseJumpToMessage
          ? null
          : jumpToMessageIndex ?? this.jumpToMessageIndex,
      showTimeMessageId: forceDisableShowTime
          ? null
          : showTimeMessageId ?? this.showTimeMessageId,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    chatMessages,
    pinnedMessageSummary,
    messageReply,
    scrollToBottom,
    showScrollToBottomIcon,
    hasOptions,
    hasSendButton,
    users,
    isUnpinSuccess,
    pinnedMessages,
    pinnedMessagesPagingStatus,
    jumpToMessageIndex,
    showTimeMessageId,
  ];
}
