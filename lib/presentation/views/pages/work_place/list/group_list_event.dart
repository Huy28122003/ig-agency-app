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
  final GroupEntity workspaceLastMessage;

  UpdateWorkspaceLastMessageEvent({required this.workspaceLastMessage});
}

class ListenWorkspaceLastMessageEvent extends GroupListEvent {}

class PinWorkspaceEvent extends GroupListEvent {
  final String workspaceId;

  PinWorkspaceEvent({required this.workspaceId});
}

class UnpinWorkspaceEvent extends GroupListEvent {
  final String workspaceId;

  UnpinWorkspaceEvent({required this.workspaceId});
}

class MuteWorkspaceEvent extends GroupListEvent {
  final String workspaceId;
  final String? unMuteTimeCode;

  MuteWorkspaceEvent({required this.workspaceId, this.unMuteTimeCode});
}

class MarkGroupEvent extends GroupListEvent {
  final String workspaceId;

  MarkGroupEvent({required this.workspaceId});
}

class DeleteWorkspaceEvent extends GroupListEvent {
  final String workspaceId;

  DeleteWorkspaceEvent({required this.workspaceId});
}

class SelectWorkspaceEvent extends GroupListEvent {
  final String id;

  SelectWorkspaceEvent({required this.id});
}

