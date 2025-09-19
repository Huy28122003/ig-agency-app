part of 'pinned_message_bottom_sheet_cubit.dart';

class PinnedMessageBottomSheetState extends Equatable {
  const PinnedMessageBottomSheetState({
    this.pageStatus = PageStatus.initial,
    this.pagingStatus = PagingStatus.idle,
    this.pinnedMessages = const [],
    this.isUnpinSuccess = false,
  });

  final List<PinnedMessageUIModel> pinnedMessages;
  final bool isUnpinSuccess;
  final PageStatus pageStatus;
  final PagingStatus pagingStatus;

  PinnedMessageBottomSheetState copyWith({
    List<PinnedMessageUIModel>? pinnedMessages,
    bool? isUnpinSuccess,
    PageStatus? pageStatus,
    PagingStatus? pagingStatus,
  }) {
    return PinnedMessageBottomSheetState(
      pinnedMessages: pinnedMessages ?? this.pinnedMessages,
      isUnpinSuccess: isUnpinSuccess ?? this.isUnpinSuccess,
      pageStatus: pageStatus ?? this.pageStatus,
      pagingStatus: pagingStatus ?? this.pagingStatus,
    );
  }

  @override
  List<Object?> get props => [
    pinnedMessages,
    isUnpinSuccess,
    pageStatus,
    pagingStatus,
  ];
}
