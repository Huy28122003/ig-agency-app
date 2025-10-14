part of 'workspace_list_bloc.dart';

class GroupListState extends BaseState<GroupListState> {
  const GroupListState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage = '',
    super.processing = false,
    this.pagingStatus = PagingStatus.idle,
    this.workspaces = const [],
    this.workspacesSearch = const [],
    this.pagingStatusSearch = PagingStatus.idle,
    this.searchKeyWord = "",
    this.searchStatus = PageStatus.initial,
    this.isSearchMode = false,
    this.workspaceSelectedId,
    this.isHaveChangeFromSearchMode = false,
  });

  final PagingStatus pagingStatus;
  final PagingStatus pagingStatusSearch;
  final List<GroupSummary> workspaces;
  final List<GroupSummary> workspacesSearch;
  final String searchKeyWord;
  final PageStatus searchStatus;
  final bool isSearchMode;
  final String? workspaceSelectedId;
  final bool isHaveChangeFromSearchMode;

  @override
  GroupListState copyWith({
    PageStatus? pageStatus,
    PageStatus? searchStatus,
    String? pageErrorMessage,
    bool? processing,
    PagingStatus? pagingStatus,
    PagingStatus? pagingStatusSearch,
    List<GroupSummary>? workspaces,
    List<GroupSummary>? workspacesSearch,
    String? searchKeyWord,
    bool? isSearchMode,
    bool? isHaveChangeFromSearchMode,
    String? workspaceSelectedId,
  }) {
    return GroupListState(
      pageStatus: pageStatus ?? this.pageStatus,
      searchStatus: searchStatus ?? this.searchStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      pagingStatus: pagingStatus ?? this.pagingStatus,
      pagingStatusSearch: pagingStatusSearch ?? this.pagingStatusSearch,
      workspaces: workspaces ?? this.workspaces,
      workspacesSearch: workspacesSearch ?? this.workspacesSearch,
      searchKeyWord: searchKeyWord ?? this.searchKeyWord,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      workspaceSelectedId: workspaceSelectedId ?? this.workspaceSelectedId,
      isHaveChangeFromSearchMode:
          isHaveChangeFromSearchMode ?? this.isHaveChangeFromSearchMode,
    );
  }

  @override
  List<Object?> get props => [
    super.props,
    pagingStatus,
    workspaces,
    workspacesSearch,
    pagingStatusSearch,
    searchKeyWord,
    searchStatus,
    isSearchMode,
    workspaceSelectedId,
    isHaveChangeFromSearchMode,
  ];
}
