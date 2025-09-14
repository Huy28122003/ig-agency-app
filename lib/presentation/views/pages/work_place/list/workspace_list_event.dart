part of 'workspace_list_bloc.dart';

sealed class WorkspaceListEvent {}

class LoadDataEvent extends WorkspaceListEvent {}

class RefreshDataEvent extends WorkspaceListEvent {}

class LoadMoreDataEvent extends WorkspaceListEvent {}

class SearchEvent extends WorkspaceListEvent {
  final String value;

  SearchEvent({required this.value});
}

class SearchDebouncedEvent extends WorkspaceListEvent {
  final String value;

  SearchDebouncedEvent(this.value);
}

class SearchKeyWorkChangeEvent extends WorkspaceListEvent {
  final String value;

  SearchKeyWorkChangeEvent({required this.value});
}

class SearchLoadMoreEvent extends WorkspaceListEvent {}

class UpdateWorkspaceLastMessageEvent extends WorkspaceListEvent {
  final WorkspaceEntity workspaceLastMessage;

  UpdateWorkspaceLastMessageEvent({required this.workspaceLastMessage});
}

class ListenWorkspaceLastMessageEvent extends WorkspaceListEvent {}

class PinWorkspaceEvent extends WorkspaceListEvent {
  final int workspaceId;

  PinWorkspaceEvent({required this.workspaceId});
}

class MuteWorkspaceEvent extends WorkspaceListEvent {
  final int workspaceId;

  MuteWorkspaceEvent({required this.workspaceId});
}

class SeenWorkspaceEvent extends WorkspaceListEvent {
  final int workspaceId;

  SeenWorkspaceEvent({required this.workspaceId});
}

class DeleteWorkspaceEvent extends WorkspaceListEvent {
  final int workspaceId;

  DeleteWorkspaceEvent({required this.workspaceId});
}

class SelectWorkspaceEvent extends WorkspaceListEvent {
  final int id;

  SelectWorkspaceEvent({required this.id});
}
