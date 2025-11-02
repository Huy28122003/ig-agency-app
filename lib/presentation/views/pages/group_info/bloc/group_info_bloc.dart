import 'package:ig_agency_app/domain/usecases/get_profile_info_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_workspace_by_id_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/leave_group_use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/update_workspace_notification_use_case.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/usecases/workspace/update_group_avatar_use_case.dart';

part 'group_info_event.dart';

part 'group_info_state.dart';

@injectable
class GroupInfoBloc extends BaseBloc<GroupInfoEvent, GroupInfoState> {
  final GetGroupInfoUseCase _getWorkspaceByIdUseCase;
  final UpdateWorkspaceNotificationUseCase _updateWorkspaceNotificationUseCase;
  final LeaveGroupUseCase _leaveGroupUseCase;
  final GetProfileInfoUseCase _getProfileInfoUseCase;
  final UpdateGroupAvatarUseCase _updateGroupAvatarUseCase;

  late final String groupId;

  GroupInfoBloc(
    this._getWorkspaceByIdUseCase,
    this._updateWorkspaceNotificationUseCase,
    this._leaveGroupUseCase,
    this._getProfileInfoUseCase,
    this._updateGroupAvatarUseCase,
  ) : super(GroupInfoState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      try {
        emit(state.copyWith(pageStatus: PageStatus.loading));
        final result = await _getWorkspaceByIdUseCase.call(event.groupId);
        emit(
          state.copyWith(
            pageStatus: PageStatus.loaded,
            avatar: result.groupAvatar,
            name: result.groupName,
            bio: result.bio,
            memberCount: result.countMember,
            pinnedMessageCount: result.countPin,
            isMute: result.isMute,
          ),
        );
      } catch (e) {
        handleError(emit, e);
      }
    });
    handleSubEvent<ToggleNotificationEvent>((event, emit) async {
      try {
        final result = await _updateWorkspaceNotificationUseCase.call(
          UpdateWorkspaceNotificationParams(
            workspaceId: groupId,
            isMute: !state.isMute,
          ),
        );
        if (result) {
          emit(state.copyWith(isMute: state.isMute));
        }
      } catch (e) {
        handleError(emit, e);
      }
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
    handleLoadData<UpdateAvatarEvent>((event, emit) async {
      try {
        if (state.avatar == event.avatar) return;
        await _updateGroupAvatarUseCase.call(
          UpdateGroupAvatarParams(workspaceId: groupId, image: event.avatar),
        );
        emit(state.copyWith(avatar: event.avatar));
      } catch (e) {
        handleError(emit, e);
      }
    });
    handleLoadData<UpdateNameEvent>((event, emit) async {
      try {
        if (state.name == event.name) return;
        emit(state.copyWith(name: event.name));
      } catch (e) {
        handleError(emit, e);
      }
    });
    handleLoadData<UpdateBioEvent>((event, emit) async {
      try {
        if (state.bio == event.bio) return;
        emit(state.copyWith(bio: event.bio));
      } catch (e) {
        handleError(emit, e);
      }
    });
  }
}
