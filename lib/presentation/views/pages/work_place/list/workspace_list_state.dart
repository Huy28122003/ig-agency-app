part of 'workspace_list_bloc.dart';

class WorkspaceListState extends BaseState<WorkspaceListState> {
  const WorkspaceListState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
    this.pagingStatus = PagingStatus.idle,
  });

  final PagingStatus pagingStatus;

  @override
  WorkspaceListState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    PagingStatus? pagingStatus,
  }) {
    return WorkspaceListState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      pagingStatus: pagingStatus ?? this.pagingStatus,
    );
  }

  @override
  List<Object?> get props => [...super.props, pagingStatus];
}
