part of 'group_info_bloc.dart';

sealed class GroupInfoEvent {}

class LoadDataEvent extends GroupInfoEvent {
  final String groupId;

  LoadDataEvent({required this.groupId});
}

class ChangeNotificationStatusEvent extends GroupInfoEvent {
  final MuteDurationOption? option;

  ChangeNotificationStatusEvent({this.option});
}

class LeaveGroupEvent extends GroupInfoEvent {}

class UpdateAvatarEvent extends GroupInfoEvent {
  final String avatar;

  UpdateAvatarEvent(this.avatar);
}

class UpdateBioEvent extends GroupInfoEvent {
  final String bio;

  UpdateBioEvent(this.bio);
}

class UpdateNameEvent extends GroupInfoEvent {
  final String name;

  UpdateNameEvent(this.name);
}
