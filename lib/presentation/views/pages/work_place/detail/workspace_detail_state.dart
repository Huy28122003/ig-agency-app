part of 'workspace_detail_bloc.dart';

class WSDetailState extends BaseState<WSDetailState> {
  const WSDetailState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.messages = const [],
    this.pinnedMessageSummary,
    this.messageReply,
    this.isNeedScrollToBottom = false,
    this.showScrollToBottomIcon = false,
  });

  final List<MessageEntity> messages;
  final PinnedMessageSummaryUiModel? pinnedMessageSummary;
  final MessageEntity? messageReply;
  final bool isNeedScrollToBottom;
  final bool showScrollToBottomIcon;

  @override
  WSDetailState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    List<MessageEntity>? messages,
    PinnedMessageSummaryUiModel? pinnedMessageSummary,
    MessageEntity? messageReply,
    bool forceCloseReplyMessage = false,
    bool? isNeedScrollToBottom,
    bool? showScrollToBottomIcon,
  }) {
    return WSDetailState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      messages: messages ?? this.messages,
      pinnedMessageSummary: pinnedMessageSummary ?? this.pinnedMessageSummary,
      messageReply: forceCloseReplyMessage
          ? null
          : messageReply ?? this.messageReply,
      isNeedScrollToBottom: isNeedScrollToBottom ?? this.isNeedScrollToBottom,
      showScrollToBottomIcon:
          showScrollToBottomIcon ?? this.showScrollToBottomIcon,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    messages,
    pinnedMessageSummary,
    messageReply,
    isNeedScrollToBottom,
    showScrollToBottomIcon,
  ];
}
