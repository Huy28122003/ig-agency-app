import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_workspaces_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'workspace_event.dart';

part 'workspace_state.dart';

@injectable
class WorkspaceBloc extends BaseBloc<WorkspaceEvent, WorkspaceState> {
  final GetWorkspacesUseCase getWorkspacesUseCase;

  WorkspaceBloc({required this.getWorkspacesUseCase})
    : super(WorkspaceState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loading));
      await Future.delayed(Duration(seconds: 1));
      final result = await getWorkspacesUseCase.call(
        GetWorkspacesParams(limit: 10, offset: 0),
      );

      if (result.success) {
        emit(
          state.copyWith(
            pageStatus: PageStatus.loaded,
            workspaces: result.data,
          ),
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
  }
}
