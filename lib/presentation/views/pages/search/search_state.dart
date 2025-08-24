part of 'search_bloc.dart';

class SearchState extends BaseState<SearchState> {
  const SearchState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage,
    super.processing,
  });

  @override
  SearchState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
  }) {
    return SearchState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
    );
  }

  @override
  List<Object?> get props => [...super.props];
}
