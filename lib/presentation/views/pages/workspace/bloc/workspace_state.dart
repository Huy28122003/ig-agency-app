part of 'workspace_bloc.dart';

class WorkspaceState extends BaseState<WorkspaceState> {
  const WorkspaceState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage = '',
    super.processing = false,
    this.pagingStatus = PagingStatus.idle,
    this.workspaces = const [],
    this.indexPage = 0,
  });

  final PagingStatus pagingStatus;
  final List<WorkspaceEntity> workspaces;
  final int indexPage;

  @override
  WorkspaceState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    PagingStatus? pagingStatus,
    int? indexPage,
    List<WorkspaceEntity>? workspaces,
  }) {
    return WorkspaceState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      pagingStatus: pagingStatus ?? this.pagingStatus,
      indexPage: indexPage ?? this.indexPage,
      workspaces: workspaces ?? this.workspaces,
    );
  }

  @override
  List<Object?> get props => [super.props, pagingStatus, indexPage, workspaces];
}
