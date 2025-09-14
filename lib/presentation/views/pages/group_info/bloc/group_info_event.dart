part of 'group_info_bloc.dart';

class GroupInfoEvent {}

class LoadDataEvent extends GroupInfoEvent {
  final int groupId;

  LoadDataEvent({required this.groupId});
}

class ToggleNotificationEvent extends GroupInfoEvent {}

class UpdateWorkspaceEvent extends GroupInfoEvent {
  final String? workspaceName;
  final String? bio;
  final bool? isMute;
  final int? countMember;

  UpdateWorkspaceEvent({
    this.workspaceName,
    this.bio,
    this.isMute,
    this.countMember,
  });
}
