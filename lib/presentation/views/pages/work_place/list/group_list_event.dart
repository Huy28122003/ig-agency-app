part of 'group_list_bloc.dart';

sealed class GroupListEvent {}

class LoadDataEvent extends GroupListEvent {}

class RefreshDataEvent extends GroupListEvent {}

class LoadMoreDataEvent extends GroupListEvent {}

class SearchEvent extends GroupListEvent {
  final String value;

  SearchEvent({required this.value});
}

class SearchDebouncedEvent extends GroupListEvent {
  final String value;

  SearchDebouncedEvent(this.value);
}

class SearchKeyWorkChangeEvent extends GroupListEvent {
  final String value;

  SearchKeyWorkChangeEvent({required this.value});
}

class SearchLoadMoreEvent extends GroupListEvent {}

class UpdateWorkspaceLastMessageEvent extends GroupListEvent {
  final GroupSummary workspaceLastMessage;

  UpdateWorkspaceLastMessageEvent({required this.workspaceLastMessage});
}

class ListenWorkspaceLastMessageEvent extends GroupListEvent {}

class PinGroupEvent extends GroupListEvent {
  final String workspaceId;

  PinGroupEvent({required this.workspaceId});
}

class UnpinGroupEvent extends GroupListEvent {
  final String workspaceId;

  UnpinGroupEvent({required this.workspaceId});
}

class ChangeNotificationStatusEvent extends GroupListEvent {
  final String groupId;
  final MuteDurationOption? type;
  final bool isEnable;

  ChangeNotificationStatusEvent({
    required this.groupId,
    this.type,
    required this.isEnable,
  });
}

class MarkGroupEvent extends GroupListEvent {
  final String groupId;
  final bool mark;

  MarkGroupEvent({required this.groupId, required this.mark});
}

class DeleteGroupEvent extends GroupListEvent {
  final String workspaceId;

  DeleteGroupEvent({required this.workspaceId});
}

class SelectWorkspaceEvent extends GroupListEvent {
  final String id;

  SelectWorkspaceEvent({required this.id});
}

class UpdateGroupEvent extends GroupListEvent {
  final String groupId;
  final String? groupName;
  final String? groupAvatar;

  UpdateGroupEvent({required this.groupId, this.groupName, this.groupAvatar});
}
