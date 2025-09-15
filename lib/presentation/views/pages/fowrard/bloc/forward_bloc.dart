import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_workspaces_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/commons/enums/status.dart';

part 'forward_event.dart';

part 'forward_state.dart';

@injectable
class ForwardBloc extends BaseBloc<ForwardEvent, ForwardState> {
  final int _limit = 15;
  int _offset = 0;
  int _searchOffset = 0;
  final GetWorkspacesUseCase getWorkspacesUseCase;
  Timer? _timer;

  ForwardBloc({required this.getWorkspacesUseCase}) : super(ForwardState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      add(GetDataEvent());
      emit(state.copyWith(pageStatus: PageStatus.loaded));
    });

    handleSubEvent<GetDataEvent>(_onGetData);

    handleSubEvent<ChangeKeyWordEvent>((event, emit) async {
      _searchOffset = 0;
      emit(state.copyWith(searchKeyWord: event.value, workspacesSearch: []));
    });

    handleSubEvent<SearchDebouncedEvent>(_onSearchDebounced);

    handleSubEvent<SearchEvent>(_onSearch);
  }

  Future<void> _onSearchDebounced(
    SearchDebouncedEvent event,
    Emitter<ForwardState> emit,
  ) async {
    emit(state.copyWith(searchStatus: PageStatus.loading));

    final result = await getWorkspacesUseCase.call(
      GetWorkspacesParams(
        keyWord: event.value,
        limit: _limit,
        offset: _searchOffset,
      ),
    );

    _searchOffset += result.length;

    final pagingStatus = _limit >= result.length
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;
    List<WorkspaceEntity> currentList = List.from(state.workspacesSearch);
    currentList.addAll(result);
    emit(
      state.copyWith(
        searchPagingStatus: pagingStatus,
        workspacesSearch: currentList,
      ),
    );
  }

  Future<void> _onSearch(SearchEvent event, Emitter<ForwardState> emit) async {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1000), () async {
      add(SearchDebouncedEvent(event.value));
    });
  }

  Future<void> _onGetData(
    GetDataEvent event,
    Emitter<ForwardState> emit,
  ) async {
    emit(state.copyWith(pagingStatus: PagingStatus.loading));

    final result = await getWorkspacesUseCase.call(
      GetWorkspacesParams(limit: _limit, offset: _offset),
    );
    _offset += result.length;

    final pagingStatus = _limit >= result.length
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;
    List<WorkspaceEntity> currentList = List.from(state.workspaces);
    currentList.addAll(result);
    emit(state.copyWith(pagingStatus: pagingStatus, workspaces: currentList));
  }
}
