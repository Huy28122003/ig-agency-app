part of 'pinned_message_list_bloc.dart';

class PinnedMessageListState extends BaseState<PinnedMessageListState> {
  const PinnedMessageListState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage = '',
    super.processing = false,
    this.pinnedMessages = const [],
    this.pagingStatus = PagingStatus.idle,
    this.isLoadedData = false,
  });

  final List<PinnedMessageUIModel> pinnedMessages;
  final PagingStatus pagingStatus;
  final bool isLoadedData;

  @override
  PinnedMessageListState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    List<PinnedMessageUIModel>? pinnedMessages,
    PagingStatus? pagingStatus,
    bool? isLoadedData,
  }) {
    return PinnedMessageListState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      pinnedMessages: pinnedMessages ?? this.pinnedMessages,
      pagingStatus: pagingStatus ?? this.pagingStatus,
      isLoadedData: isLoadedData ?? this.isLoadedData,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    pinnedMessages,
    pagingStatus,
    isLoadedData,
  ];
}
