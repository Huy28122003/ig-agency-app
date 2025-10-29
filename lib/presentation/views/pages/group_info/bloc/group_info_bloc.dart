import 'package:ig_agency_app/domain/entities/group_entity.dart';
import 'package:ig_agency_app/domain/usecases/get_profile_info_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_workspace_by_id_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/leave_group_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/update_workspace_notification_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

part 'group_info_event.dart';

part 'group_info_state.dart';

@injectable
class GroupInfoBloc extends BaseBloc<GroupInfoEvent, GroupInfoState> {
  final GetGroupInfoUseCase _getWorkspaceByIdUseCase;
  final UpdateWorkspaceNotificationUseCase _updateWorkspaceNotificationUseCase;
  final LeaveGroupUseCase _leaveGroupUseCase;
  final GetProfileInfoUseCase _getProfileInfoUseCase;
  late final String groupId;

  GroupInfoBloc(
    GetGroupInfoUseCase getWorkspaceByIdUseCase,
    UpdateWorkspaceNotificationUseCase updateWorkspaceNotificationUseCase,
    LeaveGroupUseCase leaveGroupUseCase,
    GetProfileInfoUseCase getProfileInfoUseCase,
  ) : _leaveGroupUseCase = leaveGroupUseCase,
      _updateWorkspaceNotificationUseCase = updateWorkspaceNotificationUseCase,
      _getWorkspaceByIdUseCase = getWorkspaceByIdUseCase,
      _getProfileInfoUseCase = getProfileInfoUseCase,
      super(GroupInfoState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      try {
        emit(state.copyWith(pageStatus: PageStatus.loading));
        final result = await _getWorkspaceByIdUseCase.call(event.groupId);
        emit(state.copyWith(pageStatus: PageStatus.loaded, workspace: result));
      } catch (e) {
        handleError(emit, e);
      }
    });
    handleSubEvent<ToggleNotificationEvent>((event, emit) async {
      try {
        if (state.workspace == null) return;
        final result = await _updateWorkspaceNotificationUseCase.call(
          UpdateWorkspaceNotificationParams(
            workspaceId: state.workspace!.id,
            isMute: !state.workspace!.isMute,
          ),
        );
        if (result) {
          add(UpdateWorkspaceEvent(isMute: !state.workspace!.isMute));
        }
      } catch (e) {
        handleError(emit, e);
      }
    });
    handleSubEvent<UpdateWorkspaceEvent>((event, emit) async {
      final current = state.workspace;
      if (current == null) return;

      final updated = current.copyWith(
        groupName: event.groupName,
        bio: event.bio,
        isMute: event.isMute,
        countMember: event.countMember,
      );

      emit(state.copyWith(workspace: updated));
    });
    handleLoadData<LeaveGroupEvent>((event, emit) async {
      try {
        final userInfo = await _getProfileInfoUseCase.call();
        await _leaveGroupUseCase.call(
          LeaveGroupParams(groupId: groupId, userId: userInfo.id),
        );
        emit(state.copyWith(isLeaveGroupSuccess: true));
      } catch (e) {
        handleError(emit, e);
      }
    });
  }
}
