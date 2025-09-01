import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/search.dart';
import 'package:ig_agency_app/domain/enums/filter_type.dart';
import 'package:ig_agency_app/domain/usecases/search_group_and_message_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/shared/utils/debounce.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'search_event.dart';

part 'search_state.dart';

@injectable
class SearchBloc extends BaseBloc<SearchEvent, SearchState> {
  SearchBloc(this._searchUseCase) : super(SearchState()) {
    _registerHandlers();
  }

  final SearchGroupAndMessageUseCase _searchUseCase;
  final _debounce = Debounce(milliseconds: 1000);
  final _limit = 20;
  int _offset = 0;

  void _registerHandlers() {
    handleLoadData<LoadData>(_onLoadData);
    handleSubEvent<SearchTextChanged>(_onSearchTextChanged);
    handleSubEvent<LoadMoreResult>(_onLoadMoreResult);
    handleSubEvent<ShowResultChanged>(_onShowResultChanged);
    handleSubEvent<SearchData>(_onSearchData);
    handleSubEvent<FilterTypeChanged>(_onFilterChanged);
  }

  Future<void> _onLoadData(LoadData event, Emitter<SearchState> emit) async {
    emit(state.copyWith(pageStatus: PageStatus.loaded));
  }

  Future<void> _onSearchData(
    SearchData event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(pagingStatus: PagingStatus.idle, results: []));
    _offset = 0;
    if (state.textSearch.isEmpty) {
      emit(state.copyWith(results: [], pagingStatus: PagingStatus.idle));
      return;
    }
    final result = await _searchUseCase.call(
      SearchGroupAndMessageParams(
        offset: _offset,
        limit: _limit,
        text: state.textSearch,
        type: state.filterType,
      ),
    );
    if (state.textSearch.isEmpty) {
      emit(state.copyWith(results: [], pagingStatus: PagingStatus.idle));
      return;
    }
    _offset += result.data.length;
    final pagingStatus = _offset >= result.totalRecords
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;
    emit(state.copyWith(pagingStatus: pagingStatus, results: result.data));
  }

  Future<void> _onSearchTextChanged(
    SearchTextChanged event,
    Emitter<SearchState> emit,
  ) async {
    final textSearch = event.text;
    emit(state.copyWith(results: [], textSearch: textSearch));
    if (textSearch.isEmpty) return;
    _debounce.run(() {
      add(SearchData());
    });
  }

  Future<void> _onLoadMoreResult(
    LoadMoreResult event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(pagingStatus: PagingStatus.loading));
    final result = await _searchUseCase.call(
      SearchGroupAndMessageParams(
        offset: _offset,
        limit: _limit,
        text: state.textSearch,
        type: state.filterType,
      ),
    );
    _offset += _limit;

    final pagingStatus = _offset >= result.totalRecords
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;
    List<SearchResult> currentList = List.from(state.results);
    currentList.addAll(result.data);
    emit(state.copyWith(pagingStatus: pagingStatus, results: currentList));
  }

  Future<void> _onShowResultChanged(
    ShowResultChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.isEnable) {
      emit(state.copyWith(isShowResult: event.isEnable));
    }
  }

  Future<void> _onFilterChanged(
    FilterTypeChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (state.filterType == event.type) return;
    emit(state.copyWith(filterType: event.type, results: []));
    add(SearchData());
  }
}
