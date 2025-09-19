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
    this.showOptions = true,
    this.showSendButton = false,
    this.users = const [],
    this.usersSearch = const [],
    this.chatMessagesPagingStatus = PagingStatus.idle,
    this.jumpToMessageId,
    this.scrollToTop = false,
    this.showTimeMessageId,
    this.initIndex = 0,
    this.showTagOverlay = false,
    this.groupMemberStatus = GroupMemberStatus.joined,
    this.groupSearchStatus = GroupSearchStatus.idle,
    this.isDeletedConversationSuccess = false,
    this.user,
  });

  final List<ChatMessageUIModel> chatMessages;
  final PinnedMessageSummaryUiModel? pinnedMessageSummary;
  final MessageEntity? messageReply;
  final bool scrollToBottom;
  final bool showScrollToBottomIcon;
  final bool showOptions;
  final bool showSendButton;
  final List<UserEntity> users;
  final List<UserEntity> usersSearch;
  final PagingStatus chatMessagesPagingStatus;
  final String? jumpToMessageId;
  final bool scrollToTop;
  final String? showTimeMessageId;
  final int initIndex;
  final bool showTagOverlay;
  final GroupMemberStatus groupMemberStatus;
  final GroupSearchStatus groupSearchStatus;
  final bool isDeletedConversationSuccess;
  final UserEntity? user;

  bool get needLoadMoreOldMessages =>
      chatMessagesPagingStatus != PagingStatus.empty &&
      chatMessagesPagingStatus != PagingStatus.noMoreData;

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
    bool? showOptions,
    bool? showSendButton,
    List<UserEntity>? users,
    List<UserEntity>? usersSearch,
    PagingStatus? chatMessagesPagingStatus,
    bool? hasMoreOldMessages,
    String? jumpToMessageId,
    bool? scrollToTop,
    String? showTimeMessageId,
    bool forceDisableShowTime = false,
    int? initIndex,
    bool? showTagOverlay,
    GroupMemberStatus? groupMemberStatus,
    GroupSearchStatus? groupSearchStatus,
    bool? isDeletedConversationSuccess,
    UserEntity? user,
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
      showOptions: showOptions ?? this.showOptions,
      showSendButton: showSendButton ?? this.showSendButton,
      users: users ?? this.users,
      usersSearch: usersSearch ?? this.usersSearch,
      chatMessagesPagingStatus:
          chatMessagesPagingStatus ?? this.chatMessagesPagingStatus,
      jumpToMessageId: jumpToMessageId ?? this.jumpToMessageId,
      scrollToTop: scrollToTop ?? this.scrollToTop,
      showTimeMessageId: forceDisableShowTime
          ? null
          : showTimeMessageId ?? this.showTimeMessageId,
      initIndex: initIndex ?? this.initIndex,
      showTagOverlay: showTagOverlay ?? this.showTagOverlay,
      groupMemberStatus: groupMemberStatus ?? this.groupMemberStatus,
      isDeletedConversationSuccess:
          isDeletedConversationSuccess ?? this.isDeletedConversationSuccess,
      user: user ?? this.user,
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
    showOptions,
    showSendButton,
    users,
    usersSearch,
    chatMessagesPagingStatus,
    jumpToMessageId,
    scrollToTop,
    showTimeMessageId,
    initIndex,
    showTagOverlay,
    groupMemberStatus,
    isDeletedConversationSuccess,
    user,
  ];
}
