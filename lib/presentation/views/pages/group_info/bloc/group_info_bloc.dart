import 'package:ig_agency_app/domain/entities/group_entity.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_workspace_by_id_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/update_workspace_notification_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'group_info_event.dart';

part 'group_info_state.dart';

@injectable
class GroupInfoBloc extends BaseBloc<GroupInfoEvent, GroupInfoState> {
  final GetGroupInfoUseCase getWorkspaceByIdUseCase;
  final UpdateWorkspaceNotificationUseCase updateWorkspaceNotificationUseCase;
  late final String groupId;
  GroupInfoBloc({
    required this.getWorkspaceByIdUseCase,
    required this.updateWorkspaceNotificationUseCase,
  }) : super(GroupInfoState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loading));
      final result = await getWorkspaceByIdUseCase.call(event.groupId);
      emit(state.copyWith(pageStatus: PageStatus.loaded, workspace: result));
    });
    handleSubEvent<ToggleNotificationEvent>((event, emit) async {
      if (state.workspace == null) return;
      final result = await updateWorkspaceNotificationUseCase.call(
        UpdateWorkspaceNotificationParams(
          workspaceId: state.workspace!.id,
          isMute: !state.workspace!.isMute,
        ),
      );
      if (result) {
        add(UpdateWorkspaceEvent(isMute: !state.workspace!.isMute));
      }
    });
    handleSubEvent<UpdateWorkspaceEvent>((event, emit) async {
      final current = state.workspace;
      if (current == null) return;

      final updated = current.copyWith(
        groupName: event.workspaceName,
        bio: event.bio,
        isMute: event.isMute,
        countMember: event.countMember,
      );

      emit(state.copyWith(workspace: updated));
    });
  }
}
