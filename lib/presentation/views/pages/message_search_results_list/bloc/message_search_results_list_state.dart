part of 'message_search_results_list_bloc.dart';

class MessageSearchResultsListState
    extends BaseState<MessageSearchResultsListState> {
  const MessageSearchResultsListState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage = '',
    super.processing = false,
    this.messages = const [],
    this.pagingStatus = PagingStatus.idle,
  });

  final List<MessageEntity> messages;
  final PagingStatus pagingStatus;

  @override
  MessageSearchResultsListState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    PagingStatus? pagingStatus,
    List<MessageEntity>? messages,
  }) {
    return MessageSearchResultsListState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      messages: messages ?? this.messages,
      pagingStatus: pagingStatus ?? this.pagingStatus,
    );
  }

  @override
  List<Object?> get props => [...super.props, messages, pagingStatus];
}
