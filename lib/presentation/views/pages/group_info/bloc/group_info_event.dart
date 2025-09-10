part of 'group_info_bloc.dart';

class GroupInfoEvent {}

class LoadDataEvent extends GroupInfoEvent {
  final int groupId;

  LoadDataEvent({required this.groupId});
}

class ToggleNotificationEvent extends GroupInfoEvent {}
