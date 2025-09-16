import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_workspaces_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/listen_workspace_last_message_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'workspace_list_event.dart';

part 'workspace_list_state.dart';

@injectable
class WorkspaceListBloc
    extends BaseBloc<WorkspaceListEvent, WorkspaceListState> {
  final GetWorkspacesUseCase getWorkspacesUseCase;
  final ListenWorkspaceLastMessageUseCase listenWorkspaceLastMessageUseCase;
  Timer? _timer;
  StreamSubscription<WorkspaceEntity>? _streamSubscription;

  final int _limit = 15;
  int _offset = 0;
  int _searchOffset = 0;

  WorkspaceListBloc({
    required this.getWorkspacesUseCase,
    required this.listenWorkspaceLastMessageUseCase,
  }) : super(WorkspaceListState()) {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<RefreshDataEvent>(_onRefreshData);
    handleSubEvent<LoadMoreDataEvent>(_onLoadMoreData);
    handleSubEvent<MuteWorkspaceEvent>(_onMuteWorkspace);
    handleSubEvent<PinWorkspaceEvent>(_onPinWorkspace);
    handleSubEvent<SeenWorkspaceEvent>(_onSeenWorkspace);
    handleSubEvent<UpdateWorkspaceLastMessageEvent>(
      _onUpdateWorkspaceLastMessage,
    );
    handleSubEvent<DeleteWorkspaceEvent>(_onDeleteWorkspace);
    handleSubEvent<SelectWorkspaceEvent>(_onSelectWorkspace);
    handleSubEvent<ListenWorkspaceLastMessageEvent>(
      _onListenWorkspaceLastMessage,
    );
    handleSubEvent<SearchEvent>(_onSearch);
    handleSubEvent<SearchDebouncedEvent>(_onSearchDebounced);
    handleSubEvent<SearchKeyWorkChangeEvent>(_onSearchKeyWordChange);
    handleSubEvent<SearchLoadMoreEvent>(_onSearchLoadMore);
  }

  Future<void> _onMuteWorkspace(
    MuteWorkspaceEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    List<WorkspaceEntity> workspaces = List.from(state.workspaces);
    int indexWorkspace = workspaces.indexWhere(
      (e) => e.id == event.workspaceId,
    );
    if (indexWorkspace == -1) return;
    workspaces[indexWorkspace] = workspaces[indexWorkspace].copyWith(
      isMute: !workspaces[indexWorkspace].isMute,
    );
    _sort(workspaces);
    emit(state.copyWith(workspaces: workspaces));
  }

  Future<void> _onPinWorkspace(
    PinWorkspaceEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    List<WorkspaceEntity> workspaces = List.from(state.workspaces);
    int indexWorkspace = workspaces.indexWhere(
      (e) => e.id == event.workspaceId,
    );
    if (indexWorkspace == -1) return;
    workspaces[indexWorkspace] = workspaces[indexWorkspace].copyWith(
      isPin: !workspaces[indexWorkspace].isPin,
    );
    _sort(workspaces);
    emit(state.copyWith(workspaces: workspaces));
  }

  Future<void> _onSeenWorkspace(
    SeenWorkspaceEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    List<WorkspaceEntity> workspaces = List.from(state.workspaces);
    int indexWorkspace = workspaces.indexWhere(
      (e) => e.id == event.workspaceId,
    );
    if (indexWorkspace == -1) return;
    workspaces[indexWorkspace] = workspaces[indexWorkspace].copyWith(
      isSeen: !workspaces[indexWorkspace].isSeen,
    );
    _sort(workspaces);
    emit(state.copyWith(workspaces: workspaces));
  }

  Future<void> _onUpdateWorkspaceLastMessage(
    UpdateWorkspaceLastMessageEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    List<WorkspaceEntity> workspaces = List.from(state.workspaces);

    final idx = workspaces.indexWhere(
      (e) => e.id == event.workspaceLastMessage.id,
    );
    if (idx == -1) return;

    final workspaceLastMessage = event.workspaceLastMessage;

    workspaces[idx] = workspaces[idx].copyWith(
      lastMessage: workspaceLastMessage.lastMessage,
      lastMessageTime: workspaceLastMessage.lastMessageTime,
    );

    workspaces.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

    emit(state.copyWith(workspaces: workspaces));
  }

  Future<void> _onListenWorkspaceLastMessage(
    ListenWorkspaceLastMessageEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    _streamSubscription?.cancel();
    _streamSubscription = listenWorkspaceLastMessageUseCase.call().listen((
      value,
    ) {
      add(UpdateWorkspaceLastMessageEvent(workspaceLastMessage: value));
    });
  }

  Future<void> _onSearch(
    SearchEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1000), () async {
      add(SearchDebouncedEvent(event.value));
    });
  }

  Future<void> _onSearchDebounced(
    SearchDebouncedEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    emit(state.copyWith(searchStatus: PageStatus.loading));
    _searchOffset = 0;

    final result = await getWorkspacesUseCase.call(
      GetWorkspacesParams(
        keyWord: event.value,
        limit: _limit,
        offset: _searchOffset,
      ),
    );

    _searchOffset += result.length;
    final pagingStatus = _limit > result.length
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;
    emit(
      state.copyWith(
        pagingStatusSearch: pagingStatus,
        searchStatus: PageStatus.loaded,
        workspacesSearch: result,
      ),
    );
  }

  Future<void> _onSearchKeyWordChange(
    SearchKeyWorkChangeEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    emit(state.copyWith(searchKeyWord: event.value));
  }

  Future<void> _onSearchLoadMore(
    SearchLoadMoreEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    emit(state.copyWith(pagingStatusSearch: PagingStatus.loading));

    await Future.delayed(Duration(seconds: 1));
    final result = await getWorkspacesUseCase.call(
      GetWorkspacesParams(
        limit: _limit,
        offset: _searchOffset,
        keyWord: state.searchKeyWord,
      ),
    );
    _searchOffset += result.length;

    final pagingStatus = _limit > result.length
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;

    final next = List<WorkspaceEntity>.from(state.workspacesSearch)
      ..addAll(result);
    emit(
      state.copyWith(pagingStatusSearch: pagingStatus, workspacesSearch: next),
    );
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loaded));
    await Future.delayed(Duration(seconds: 1));
    final result = await getWorkspacesUseCase.call(
      GetWorkspacesParams(limit: 15, offset: _offset),
    );

    _offset += result.length;

    final pagingStatus = _limit > result.length
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;

    List<WorkspaceEntity> workspaces = result;
    _sort(workspaces);
    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        workspaces: workspaces,
        pagingStatus: pagingStatus,
      ),
    );
  }

  Future<void> _onRefreshData(
    RefreshDataEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    emit(state.copyWith(pagingStatus: PagingStatus.refreshing));

    _offset = 0;
    await Future.delayed(Duration(seconds: 1));
    final result = await getWorkspacesUseCase.call(
      GetWorkspacesParams(limit: _limit, offset: _offset),
    );

    _offset += result.length;

    List<WorkspaceEntity>? workspaces = result;
    _sort(workspaces);
    emit(
      state.copyWith(
        pagingStatus: PagingStatus.refreshCompleted,
        workspaces: workspaces,
      ),
    );
  }

  Future<void> _onLoadMoreData(
    LoadMoreDataEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    emit(state.copyWith(pagingStatus: PagingStatus.loading));

    await Future.delayed(Duration(seconds: 1));
    final result = await getWorkspacesUseCase.call(
      GetWorkspacesParams(limit: _limit, offset: _offset),
    );

    _offset += result.length;
    final pagingStatus = _limit > result.length
        ? PagingStatus.noMoreData
        : PagingStatus.loadCompleted;
    final next = List<WorkspaceEntity>.from(state.workspaces)..addAll(result);
    emit(state.copyWith(pagingStatus: pagingStatus, workspaces: next));
  }

  Future<void> _onDeleteWorkspace(
    DeleteWorkspaceEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    List<WorkspaceEntity> workspaces = List.from(state.workspaces);
    workspaces.removeWhere((e) => e.id == event.workspaceId);
    emit(state.copyWith(workspaces: workspaces));
  }

  void _sort(List<WorkspaceEntity> workspaces) {
    _sortWorkspacesByTime(workspaces);
    _sortWorkspacesByPin(workspaces);
  }

  void _sortWorkspacesByPin(List<WorkspaceEntity> workspaces) {
    if (workspaces.isEmpty) return;
    workspaces.sort((a, b) {
      if (a.isPin == b.isPin) return 0;
      return a.isPin ? -1 : 1;
    });
  }

  void _sortWorkspacesByTime(List<WorkspaceEntity> workspaces) {
    if (workspaces.isEmpty) return;
    workspaces.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
  }

  Future<void> _onSelectWorkspace(
    SelectWorkspaceEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    emit(state.copyWith(workspaceSelectedId: event.id));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _streamSubscription?.cancel();
    return super.close();
  }
}
