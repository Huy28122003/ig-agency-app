import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/usecases/workspace/delete_group_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_workspaces_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/listen_workspace_last_message_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/pin_group_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/unpin_group_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'workspace_list_event.dart';

part 'workspace_list_state.dart';

@injectable
class GroupListBloc
    extends BaseBloc<WorkspaceListEvent, WorkspaceListState> {
  final GetGroupUseCase getWorkspacesUseCase;
  final ListenWorkspaceLastMessageUseCase listenWorkspaceLastMessageUseCase;
  final PinGroupUseCase pinGroupUseCase;
  final UnpinGroupUseCase unpinGroupUseCase;
  final DeleteGroupUseCase deleteGroupUseCase;

  Timer? _timer;
  StreamSubscription<GroupEntity>? _streamSubscription;

  final int _limit = 15;
  int _offset = 0;
  int _searchOffset = 0;

  GroupListBloc({
    required this.getWorkspacesUseCase,
    required this.listenWorkspaceLastMessageUseCase,
    required this.pinGroupUseCase,
    required this.unpinGroupUseCase,
    required this.deleteGroupUseCase,
  }) : super(WorkspaceListState()) {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<RefreshDataEvent>(_onRefreshData);
    handleSubEvent<LoadMoreDataEvent>(_onLoadMoreData);
    handleSubEvent<MuteWorkspaceEvent>(_onMuteWorkspace);
    handleSubEvent<PinWorkspaceEvent>(_onPinWorkspace);
    handleSubEvent<UnpinWorkspaceEvent>(_onUnpinWorkspace);
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
    List<GroupEntity> workspaces = List.from(state.workspaces);
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
    try {
      await pinGroupUseCase.call(event.workspaceId);
      List<GroupEntity> workspaces = List.from(state.workspaces);
      int indexWorkspace = workspaces.indexWhere(
        (e) => e.id == event.workspaceId,
      );
      if (indexWorkspace == -1) return;
      workspaces[indexWorkspace] = workspaces[indexWorkspace].copyWith(
        isPin: !workspaces[indexWorkspace].isPin,
      );
      _sort(workspaces);
      emit(state.copyWith(workspaces: workspaces));
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onUnpinWorkspace(
    UnpinWorkspaceEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    try {
      await unpinGroupUseCase.call(event.workspaceId);
      List<GroupEntity> workspaces = List.from(state.workspaces);

      int indexWorkspace = workspaces.indexWhere(
        (e) => e.id == event.workspaceId,
      );
      if (indexWorkspace == -1) return;

      final target = workspaces[indexWorkspace].copyWith(isPin: false);

      final oldest = workspaces
          .where((e) => e.lastMessageTime != null)
          .reduce(
            (a, b) => (a.lastMessageTime!.isBefore(b.lastMessageTime!)) ? a : b,
          );

      if (target.lastMessageTime != null &&
          oldest.id == target.id &&
          _offset % 15 == 0) {
        workspaces.removeAt(indexWorkspace);
        _offset -= 1;
      } else {
        workspaces[indexWorkspace] = target;
        _sort(workspaces);
      }

      emit(state.copyWith(workspaces: workspaces));
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onSeenWorkspace(
    SeenWorkspaceEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    List<GroupEntity> workspaces = List.from(state.workspaces);
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
    List<GroupEntity> workspaces = List.from(state.workspaces);

    final idx = workspaces.indexWhere(
      (e) => e.id == event.workspaceLastMessage.id,
    );
    if (idx == -1) return;

    final workspaceLastMessage = event.workspaceLastMessage;

    workspaces[idx] = workspaces[idx].copyWith(
      lastMessage: workspaceLastMessage.lastMessage,
      lastMessageTime: workspaceLastMessage.lastMessageTime,
    );

    final now = DateTime.now();
    workspaces.sort(
      (a, b) => (b.lastMessageTime ?? now).compareTo(a.lastMessageTime ?? now),
    );

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

    final next = List<GroupEntity>.from(state.workspacesSearch)
      ..addAll(result);
    emit(
      state.copyWith(pagingStatusSearch: pagingStatus, workspacesSearch: next),
    );
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    try {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
      final result = await getWorkspacesUseCase.call(
        GetWorkspacesParams(limit: 15, offset: _offset),
      );

      _offset += result.length;

      final pagingStatus = _limit > result.length
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;

      List<GroupEntity> workspaces = result;
      // @Huy20031228: api sap xep truoc khi tra ve nen se khong can sap xep nua
      // _sort(workspaces);
      emit(
        state.copyWith(
          pageStatus: PageStatus.loaded,
          workspaces: workspaces,
          pagingStatus: pagingStatus,
        ),
      );
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onRefreshData(
    RefreshDataEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    try {
      emit(state.copyWith(pagingStatus: PagingStatus.refreshing));

      _offset = 0;
      final result = await getWorkspacesUseCase.call(
        GetWorkspacesParams(limit: _limit, offset: _offset),
      );

      _offset += result.length;

      List<GroupEntity>? workspaces = result;
      // _sort(workspaces);
      emit(
        state.copyWith(
          pagingStatus: PagingStatus.refreshCompleted,
          workspaces: workspaces,
        ),
      );
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onLoadMoreData(
    LoadMoreDataEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    try {
      emit(state.copyWith(pagingStatus: PagingStatus.loading));

      final result = await getWorkspacesUseCase.call(
        GetWorkspacesParams(limit: _limit, offset: _offset),
      );

      _offset += result.length;
      final pagingStatus = _limit > result.length
          ? PagingStatus.noMoreData
          : PagingStatus.loadCompleted;
      final next = List<GroupEntity>.from(state.workspaces)..addAll(result);
      emit(state.copyWith(pagingStatus: pagingStatus, workspaces: next));
    } catch (e) {
      handleError(emit, e);
    }
  }

  Future<void> _onDeleteWorkspace(
    DeleteWorkspaceEvent event,
    Emitter<WorkspaceListState> emit,
  ) async {
    try {
      await deleteGroupUseCase.call(event.workspaceId);
      _offset -= 1;
      List<GroupEntity> workspaces = List.from(state.workspaces);
      workspaces.removeWhere((e) => e.id == event.workspaceId);
      emit(state.copyWith(workspaces: workspaces));
    } catch (e) {
      handleError(emit, e);
    }
  }

  void _sort(List<GroupEntity> workspaces) {
    _sortWorkspacesByTime(workspaces);
    _sortWorkspacesByPin(workspaces);
  }

  void _sortWorkspacesByPin(List<GroupEntity> workspaces) {
    if (workspaces.isEmpty) return;
    workspaces.sort((a, b) {
      if (a.isPin == b.isPin) return 0;
      return a.isPin ? -1 : 1;
    });
  }

  void _sortWorkspacesByTime(List<GroupEntity> workspaces) {
    if (workspaces.isEmpty) return;
    //tao thoi gian trong qua khu de cac group chua co tin nhan moi nao se sap xep ve cuoi
    final defaultTime = DateTime(2023);

    workspaces.sort(
      (a, b) => (b.lastMessageTime ?? defaultTime).compareTo(
        a.lastMessageTime ?? defaultTime,
      ),
    );
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

  @override
  void handleError(Emitter<WorkspaceListState> emit, Object error) {
    super.handleError(emit, error);
  }
}
