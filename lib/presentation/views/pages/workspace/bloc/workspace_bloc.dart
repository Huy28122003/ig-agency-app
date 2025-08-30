import 'dart:async';
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
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loading));
      await Future.delayed(Duration(seconds: 1));
      final result = await getWorkspacesUseCase.call(
        GetWorkspacesParams(limit: 10, offset: 0),
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
    });

    handleSubEvent<RefreshDataEvent>((event, emit) async {
      emit(state.copyWith(pagingStatus: PagingStatus.refreshing));

      await Future.delayed(Duration(seconds: 1));
      final result = await getWorkspacesUseCase.call(
        GetWorkspacesParams(limit: 10, offset: 0),
      );

      if (result.success) {
        emit(
          state.copyWith(
            pagingStatus: PagingStatus.refreshCompleted,
            workspaces: result.data,
          ),
        );
      } else {
        emit(state.copyWith(pagingStatus: PagingStatus.refreshFailed));
      }
    });

    handleSubEvent<LoadMoreDataEvent>((event, emit) async {
      emit(state.copyWith(pagingStatus: PagingStatus.loading));

      await Future.delayed(Duration(seconds: 1));
      final result = await getWorkspacesUseCase.call(
        GetWorkspacesParams(limit: 10, offset: state.indexPage * 10),
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
    });

    handleSubEvent<SearchEvent>((event, emit) async {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 1000), () async {
        add(SearchDebouncedEvent(event.value));
      });
    });

    handleSubEvent<SearchDebouncedEvent>((event, emit) async {
      emit(state.copyWith(searchStatus: PageStatus.loading));

      final result = await getWorkspacesUseCase.call(
        GetWorkspacesParams(keyWord: event.value, limit: 10, offset: 0),
      );

      if (result.success) {
        emit(
          state.copyWith(
            searchStatus: PageStatus.loaded,
            workspacesSearch: result.data,
          ),
        );
      } else {
        emit(state.copyWith(searchStatus: PageStatus.failure));
      }
    });

    handleSubEvent<SearchKeyWorkChangeEvent>((event, emit) async {
      emit(state.copyWith(searchKeyWord: event.value));
    });

    handleSubEvent<SearchLoadMoreEvent>((event, emit) async {
      emit(state.copyWith(pagingStatusSearch: PagingStatus.loading));

      await Future.delayed(Duration(seconds: 1));
      final result = await getWorkspacesUseCase.call(
        GetWorkspacesParams(limit: 10, offset: state.indexPageSearch * 10),
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
    });
    handleSubEvent<UpdateWorkspaceLastMessageEvent>((event, emit) async {
      List<WorkspaceEntity> workspaces = List<WorkspaceEntity>.from(
        state.workspaces,
      );

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
    });

    handleSubEvent<ListenWorkspaceLastMessageEvent>((event, emit) async {
      _streamSubscription?.cancel();
      _streamSubscription = listenWorkspaceLastMessageUseCase.call().listen((
        value,
      ) {
        add(UpdateWorkspaceLastMessageEvent(workspaceLastMessage: value));
      });
    });

    handleSubEvent<SeenWorkspaceEvent>((event, emit) async {});
  }

  void _sort(List<WorkspaceEntity> workspaces) {
    _sortWorkspacesByTime(workspaces);
    _sortWorkspacesByPin(workspaces);
  }

  void _sortWorkspacesByPin(List<WorkspaceEntity> workspaces) {
    if (workspaces.isEmpty) return;
    workspaces.sort((a, b) {
      if (a.isPin == b.isPin) {
        return 0;
      }
      return a.isPin ? -1 : 1;
    });
  }

  void _sortWorkspacesByTime(List<WorkspaceEntity> workspaces) {
    if (workspaces.isEmpty) return;
    workspaces.sort((a, b) {
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });
  }
}
