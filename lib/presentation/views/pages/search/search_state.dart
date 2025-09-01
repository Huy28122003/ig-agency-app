part of 'search_bloc.dart';

class SearchState extends BaseState<SearchState> {
  const SearchState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing,
    this.pagingStatus = PagingStatus.loadCompleted,
    this.results = const [],
    this.isShowResult = false,
    this.textSearch = '',
    this.filterType = FilterType.group,
  });

  final PagingStatus pagingStatus;
  final List<SearchResult> results;
  final bool isShowResult;
  final String textSearch;
  final FilterType filterType;

  @override
  SearchState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    PagingStatus? pagingStatus,
    List<SearchResult>? results,
    bool? isShowResult,
    String? textSearch,
    FilterType? filterType,
  }) {
    return SearchState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      pagingStatus: pagingStatus ?? this.pagingStatus,
      results: results ?? this.results,
      isShowResult: isShowResult ?? this.isShowResult,
      textSearch: textSearch ?? this.textSearch,
      filterType: filterType ?? this.filterType,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    pagingStatus,
    results,
    isShowResult,
    textSearch,
    filterType,
  ];
}
