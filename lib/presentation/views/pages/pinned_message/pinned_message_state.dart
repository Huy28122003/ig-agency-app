part of 'pinned_message_bloc.dart';

class PinnedMessageState extends BaseState<PinnedMessageState> {
  const PinnedMessageState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.pagingStatus = PagingStatus.idle,
    this.messages = const [],
  });

  final PagingStatus pagingStatus;
  final List<PinnedMessageUIModel> messages;

  @override
  PinnedMessageState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    PagingStatus? pagingStatus,
    List<PinnedMessageUIModel>? messages,
  }) {
    return PinnedMessageState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      pagingStatus: pagingStatus ?? this.pagingStatus,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [...super.props, pagingStatus, messages];
}
