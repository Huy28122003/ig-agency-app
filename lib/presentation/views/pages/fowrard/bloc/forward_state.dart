part of 'forward_bloc.dart';

class ForwardState extends BaseState<ForwardState> {
  const ForwardState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage = '',
    super.processing = false,
    this.workspaces = const [],
    this.workspacesSearch = const [],
    this.sentGroups = const [],
    this.pagingStatus = PagingStatus.idle,
    this.searchPagingStatus = PagingStatus.idle,
    this.searchKeyWord = "",
    this.searchStatus = PageStatus.initial,
  });

  final PageStatus searchStatus;

  final List<GroupEntity> workspaces;
  final List<GroupEntity> workspacesSearch;
  final PagingStatus pagingStatus;
  final PagingStatus searchPagingStatus;
  final String searchKeyWord;
  final List<String> sentGroups;

  @override
  ForwardState copyWith({
    PageStatus? pageStatus,
    PageStatus? searchStatus,
    String? pageErrorMessage,
    String? searchKeyWord,
    bool? processing,
    List<GroupEntity>? workspaces,
    List<GroupEntity>? workspacesSearch,
    List<String>? sentGroups,
    PagingStatus? pagingStatus,
    PagingStatus? searchPagingStatus,
  }) {
    return ForwardState(
      pageStatus: pageStatus ?? this.pageStatus,
      searchStatus: searchStatus ?? this.searchStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      workspaces: workspaces ?? this.workspaces,
      searchKeyWord: searchKeyWord ?? this.searchKeyWord,
      pagingStatus: pagingStatus ?? this.pagingStatus,
      workspacesSearch: workspacesSearch ?? this.workspacesSearch,
      searchPagingStatus: searchPagingStatus ?? this.searchPagingStatus,
      sentGroups: sentGroups ?? this.sentGroups,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    workspaces,
    pagingStatus,
    searchKeyWord,
    workspacesSearch,
    searchStatus,
    searchPagingStatus,
    sentGroups,
  ];
}
