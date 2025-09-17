import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../domain/repositories/workspace_repository.dart';
import '../../../../../shared/commons/models/pagination.dart';

part 'create_group_event.dart';
part 'create_group_state.dart';

@injectable
class CreateGroupBloc extends BaseBloc<CreateGroupEvent, CreateGroupState> {
  final WorkspaceRepository _repo;

  CreateGroupBloc({required WorkspaceRepository repo})
    : _repo = repo,
      super(CreateGroupState()) {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<LoadMoreDataEvent>(_onLoadMoreData);
    handleSubEvent<GroupNameChangedEvent>(_onGroupNameChanged);
    on<SearchKeyWordChangedEvent>(
      _onSearchKeyWordChanged,
      transformer: (event, mapper) =>
          event.debounceTime(const Duration(milliseconds: 500)).flatMap(mapper),
    );
    on<SelectUserEvent>(_onSelectUser);
    handleSubEvent<SubmitCreateGroupEvent>(_onSubmitCreateGroup);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    emit(
      state.copyWith(
        pageStatus: PageStatus.loading,
        pagination: const Pagination(page: 0),
        listUser: [],
      ),
    );

    final List<UserEntity> listUser = await _repo.getListUser(
      pagination: state.pagination,
      keySearch: state.searchKeyWord,
    );

    final hasMore = listUser.length >= state.pagination.limit;

    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        listUser: listUser,
        pagination: state.pagination.copyWith(hasMore: hasMore),
      ),
    );
  }

  Future<void> _onLoadMoreData(
    LoadMoreDataEvent event,
    Emitter<CreateGroupState> emit,
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

    final List<UserEntity> listUser = await _repo.getListUser(
      pagination: pagination,
      keySearch: state.searchKeyWord,
    );

    final hasMore = listUser.length >= state.pagination.limit;

    emit(
      state.copyWith(
        listUser: [...state.listUser] + listUser,
        pagination: pagination.copyWith(hasMore: hasMore, isLoadingMore: false),
      ),
    );
  }

  Future<void> _onGroupNameChanged(
    GroupNameChangedEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    emit(state.copyWith(groupName: event.groupName));
  }

  Future<void> _onSearchKeyWordChanged(
    SearchKeyWordChangedEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    emit(state.copyWith(searchKeyWord: event.searchKeyWord));
    await _onLoadData(LoadDataEvent(), emit);
  }

  Future<void> _onSelectUser(
    SelectUserEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    final List<UserEntity> listSelectedUser = [...state.listSelectedUser];
    if (event.isSelected) {
      listSelectedUser.add(event.user);
    } else {
      listSelectedUser.removeWhere((element) => element.id == event.user.id);
    }
    emit(state.copyWith(listSelectedUser: listSelectedUser));
  }

  Future<void> _onSubmitCreateGroup(
    SubmitCreateGroupEvent event,
    Emitter<CreateGroupState> emit,
  ) async {
    emit(state.copyWith(processing: true));

    final value = await _repo.createGroup(
      state.groupName,
      state.listSelectedUser,
    );

    emit(state.copyWith(createGroupSuccess: value, processing: false));
  }
}
