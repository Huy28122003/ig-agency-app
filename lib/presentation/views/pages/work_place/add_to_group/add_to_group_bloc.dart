import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../domain/entities/workspace_entity.dart';
import '../../../../../domain/repositories/workspace_repository.dart';
import '../../../../../shared/commons/models/pagination.dart';

part 'add_to_group_event.dart';
part 'add_to_group_state.dart';

@injectable
class AddToGroupBloc extends BaseBloc<AddToGroupEvent, AddToGroupState> {
  final WorkspaceRepository _repo;

  AddToGroupBloc({required WorkspaceRepository repo})
    : _repo = repo,
      super(AddToGroupState()) {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<LoadMoreDataEvent>(_onLoadMoreData);
    on<SearchKeyWordChangedEvent>(
      _onSearchKeyWordChanged,
      transformer: (event, mapper) =>
          event.debounceTime(const Duration(milliseconds: 500)).flatMap(mapper),
    );
    on<SelectGroupEvent>(_onSelectUser);
    handleSubEvent<SubmitAddToGroupEvent>(_onSubmitAddToGroup);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<AddToGroupState> emit,
  ) async {
    emit(
      state.copyWith(
        pageStatus: PageStatus.loading,
        pagination: const Pagination(page: 0),
        listGroup: [],
      ),
    );

    final List<WorkspaceEntity> listGroup = await _repo.getListGroup(
      pagination: state.pagination,
      keySearch: state.searchKeyWord,
    );

    final hasMore = listGroup.length >= state.pagination.limit;

    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        listGroup: listGroup,
        pagination: state.pagination.copyWith(hasMore: hasMore),
      ),
    );
  }

  Future<void> _onLoadMoreData(
    LoadMoreDataEvent event,
    Emitter<AddToGroupState> emit,
  ) async {
    if (!state.pagination.readyToLoadMore) {
      return;
    }

    emit(
      state.copyWith(
        pagination: state.pagination.copyWith(isLoadingMore: true),
      ),
    );

    final Pagination pagination = state.pagination.copyWith(
      page: state.pagination.page + 1,
    );

    final List<WorkspaceEntity> listGroup = await _repo.getListGroup(
      pagination: pagination,
      keySearch: state.searchKeyWord,
    );

    final hasMore = listGroup.length >= state.pagination.limit;

    emit(
      state.copyWith(
        listGroup: [...state.listGroup] + listGroup,
        pagination: pagination.copyWith(hasMore: hasMore, isLoadingMore: false),
      ),
    );
  }

  Future<void> _onSearchKeyWordChanged(
    SearchKeyWordChangedEvent event,
    Emitter<AddToGroupState> emit,
  ) async {
    emit(state.copyWith(searchKeyWord: event.searchKeyWord));
    await _onLoadData(LoadDataEvent(), emit);
  }

  Future<void> _onSelectUser(
    SelectGroupEvent event,
    Emitter<AddToGroupState> emit,
  ) async {
    final List<WorkspaceEntity> listSelectedGroup = [
      ...state.listSelectedGroup,
    ];
    if (event.isSelected) {
      listSelectedGroup.add(event.group);
    } else {
      listSelectedGroup.removeWhere((element) => element.id == event.group.id);
    }
    emit(state.copyWith(listSelectedGroup: listSelectedGroup));
  }

  Future<void> _onSubmitAddToGroup(
    SubmitAddToGroupEvent event,
    Emitter<AddToGroupState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    final value = await _repo.addUserToGroups(
      state.user,
      state.listSelectedGroup,
    );

    emit(state.copyWith(addToGroupSuccess: value, processing: false));
  }
}
