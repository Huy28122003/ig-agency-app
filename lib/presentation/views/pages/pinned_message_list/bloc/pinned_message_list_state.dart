part of 'pinned_message_list_bloc.dart';

class PinnedMessageListState extends BaseState<PinnedMessageListState> {
  const PinnedMessageListState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage = '',
    super.processing = false,
    this.pinnedMessages = const [],
    this.pagingStatus = PagingStatus.idle,
  });

  final List<MessageEntity> pinnedMessages;
  final PagingStatus pagingStatus;

  @override
  PinnedMessageListState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    List<MessageEntity>? pinnedMessages,
    PagingStatus? pagingStatus,
  }) {
    return PinnedMessageListState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      pinnedMessages: pinnedMessages ?? this.pinnedMessages,
      pagingStatus: pagingStatus ?? this.pagingStatus,
    );
  }

  @override
  List<Object?> get props => [...super.props, pinnedMessages, pagingStatus];
}
