import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_workspaces_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/listen_workspace_last_message_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'workspace_event.dart';

part 'workspace_state.dart';

@injectable
class WorkspaceBloc extends BaseBloc<WorkspaceEvent, WorkspaceState> {
  final GetWorkspacesUseCase getWorkspacesUseCase;
  final ListenWorkspaceLastMessageUseCase listenWorkspaceLastMessageUseCase;
  Timer? _timer;
  StreamSubscription<WorkspaceEntity>? _streamSubscription;

  WorkspaceBloc({
    required this.getWorkspacesUseCase,
    required this.listenWorkspaceLastMessageUseCase,
  }) : super(WorkspaceState()) {
    handleSubEvent<MuteWorkspaceEvent>(_onMuteWorkspace);
    handleSubEvent<PinWorkspaceEvent>(_onPinWorkspace);
    handleSubEvent<SeenWorkspaceEvent>(_onSeenWorkspace);
    handleSubEvent<UpdateWorkspaceLastMessageEvent>(
      _onUpdateWorkspaceLastMessage,
    );
    handleSubEvent<ListenWorkspaceLastMessageEvent>(
      _onListenWorkspaceLastMessage,
    );
    handleSubEvent<SearchEvent>(_onSearch);
    handleSubEvent<SearchDebouncedEvent>(_onSearchDebounced);
    handleSubEvent<SearchKeyWorkChangeEvent>(_onSearchKeyWordChange);
    handleSubEvent<SearchLoadMoreEvent>(_onSearchLoadMore);
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<RefreshDataEvent>(_onRefreshData);
    handleSubEvent<LoadMoreDataEvent>(_onLoadMoreData);
  }

  Future<void> _onMuteWorkspace(
    MuteWorkspaceEvent event,
    Emitter<WorkspaceState> emit,
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
    Emitter<WorkspaceState> emit,
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
    Emitter<WorkspaceState> emit,
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
    Emitter<WorkspaceState> emit,
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
    Emitter<WorkspaceState> emit,
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
    Emitter<WorkspaceState> emit,
  ) async {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1000), () async {
      add(SearchDebouncedEvent(event.value));
    });
  }

  Future<void> _onSearchDebounced(
    SearchDebouncedEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(searchStatus: PageStatus.loading));

    final result = await getWorkspacesUseCase.call(
      GetWorkspacesParams(keyWord: event.value, limit: 10, offset: 1),
    );

    if (result.success) {
      emit(
        state.copyWith(
          searchStatus: PageStatus.loaded,
          workspacesSearch: result.data,
          indexPageSearch: 1,
        ),
      );
    } else {
      emit(state.copyWith(searchStatus: PageStatus.failure));
    }
  }

  Future<void> _onSearchKeyWordChange(
    SearchKeyWorkChangeEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(searchKeyWord: event.value));
  }

  Future<void> _onSearchLoadMore(
    SearchLoadMoreEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(pagingStatusSearch: PagingStatus.loading));

    await Future.delayed(Duration(seconds: 1));
    final result = await getWorkspacesUseCase.call(
      GetWorkspacesParams(limit: 10, offset: state.indexPageSearch + 1),
    );

    if (result.success && result.data != null && result.data!.isNotEmpty) {
      List<WorkspaceEntity> workspaces = state.workspaces;
      workspaces.addAll(result.data!);
      emit(
        state.copyWith(
          pagingStatusSearch: PagingStatus.loadCompleted,
          workspaces: workspaces,
          indexPageSearch: state.indexPageSearch + 1,
        ),
      );
    } else {
      emit(state.copyWith(pagingStatusSearch: PagingStatus.loadFailed));
    }
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));
    await Future.delayed(Duration(seconds: 1));
    final result = await getWorkspacesUseCase.call(
      GetWorkspacesParams(limit: 10, offset: state.indexPage),
    );

    if (result.success) {
      List<WorkspaceEntity>? workspaces = result.data;
      _sort(workspaces ?? []);
      emit(
        state.copyWith(pageStatus: PageStatus.loaded, workspaces: workspaces),
      );
    } else {
      emit(state.copyWith(pageStatus: PageStatus.failure));
    }
  }

  Future<void> _onRefreshData(
    RefreshDataEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(pagingStatus: PagingStatus.refreshing));

    await Future.delayed(Duration(seconds: 1));
    final result = await getWorkspacesUseCase.call(
      GetWorkspacesParams(limit: 10, offset: 1),
    );

    if (result.success) {
      List<WorkspaceEntity>? workspaces = result.data;
      _sort(workspaces ?? []);
      emit(
        state.copyWith(
          pagingStatus: PagingStatus.refreshCompleted,
          workspaces: workspaces,
          indexPage: 1,
        ),
      );
    } else {
      emit(state.copyWith(pagingStatus: PagingStatus.refreshFailed));
    }
  }

  Future<void> _onLoadMoreData(
    LoadMoreDataEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(pagingStatus: PagingStatus.loading));

    await Future.delayed(Duration(seconds: 1));
    final result = await getWorkspacesUseCase.call(
      GetWorkspacesParams(limit: 10, offset: state.indexPage + 1),
    );

    if (result.success && result.data != null && result.data!.isNotEmpty) {
      List<WorkspaceEntity> workspaces = state.workspaces;
      workspaces.addAll(result.data!);
      emit(
        state.copyWith(
          pagingStatus: PagingStatus.loadCompleted,
          workspaces: workspaces,
          indexPage: state.indexPage + 1,
        ),
      );
    } else {
      emit(state.copyWith(pagingStatus: PagingStatus.loadFailed));
    }
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
}
