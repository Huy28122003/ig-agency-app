part of 'workspace_bloc.dart';

class WorkspaceState extends BaseState<WorkspaceState> {
  const WorkspaceState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage = '',
    super.processing = false,
    this.pagingStatus = PagingStatus.idle,
    this.workspaces = const [],
    this.indexPage = 1,
    this.workspacesSearch = const [],
    this.indexPageSearch = 1,
    this.pagingStatusSearch = PagingStatus.idle,
    this.searchKeyWord = "",
    this.searchStatus = PageStatus.initial,
  });

  final PagingStatus pagingStatus;
  final PagingStatus pagingStatusSearch;
  final List<WorkspaceEntity> workspaces;
  final List<WorkspaceEntity> workspacesSearch;
  final int indexPage;
  final int indexPageSearch;
  final String searchKeyWord;
  final PageStatus searchStatus;

  @override
  WorkspaceState copyWith({
    PageStatus? pageStatus,
    PageStatus? searchStatus,
    String? pageErrorMessage,
    bool? processing,
    PagingStatus? pagingStatus,
    PagingStatus? pagingStatusSearch,
    int? indexPage,
    int? indexPageSearch,
    List<WorkspaceEntity>? workspaces,
    List<WorkspaceEntity>? workspacesSearch,
    String? searchKeyWord,
  }) {
    return WorkspaceState(
      pageStatus: pageStatus ?? this.pageStatus,
      searchStatus: searchStatus ?? this.searchStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      pagingStatus: pagingStatus ?? this.pagingStatus,
      pagingStatusSearch: pagingStatusSearch ?? this.pagingStatusSearch,
      indexPage: indexPage ?? this.indexPage,
      indexPageSearch: indexPageSearch ?? this.indexPageSearch,
      workspaces: workspaces ?? this.workspaces,
      workspacesSearch: workspacesSearch ?? this.workspacesSearch,
      searchKeyWord: searchKeyWord ?? this.searchKeyWord,
    );
  }

  @override
  List<Object?> get props => [
    super.props,
    pagingStatus,
    indexPage,
    workspaces,
    workspacesSearch,
    indexPageSearch,
    pagingStatusSearch,
    searchKeyWord,
    searchStatus,
  ];
}
