part of 'group_info_bloc.dart';

class GroupInfoEvent {}

class LoadDataEvent extends GroupInfoEvent {
  final String groupId;

  LoadDataEvent({required this.groupId});
}

class ToggleNotificationEvent extends GroupInfoEvent {}

class UpdateWorkspaceEvent extends GroupInfoEvent {
  final String? groupName;
  final String? bio;
  final bool? isMute;
  final int? countMember;

  UpdateWorkspaceEvent({
    this.groupName,
    this.bio,
    this.isMute,
    this.countMember,
  });
}

class LeaveGroupEvent extends GroupInfoEvent {}
