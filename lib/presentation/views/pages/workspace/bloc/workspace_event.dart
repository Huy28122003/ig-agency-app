part of 'workspace_bloc.dart';

sealed class WorkspaceEvent {}

class LoadDataEvent extends WorkspaceEvent {}

class RefreshDataEvent extends WorkspaceEvent {}

class LoadMoreDataEvent extends WorkspaceEvent {}

class SearchEvent extends WorkspaceEvent {
  final String value;

  SearchEvent({required this.value});
}

class SearchDebouncedEvent extends WorkspaceEvent {
  final String value;

  SearchDebouncedEvent(this.value);
}

class SearchKeyWorkChangeEvent extends WorkspaceEvent {
  final String value;

  SearchKeyWorkChangeEvent({required this.value});
}

class SearchLoadMoreEvent extends WorkspaceEvent {}

class UpdateWorkspaceLastMessageEvent extends WorkspaceEvent {
  final WorkspaceEntity workspaceLastMessage;

  UpdateWorkspaceLastMessageEvent({required this.workspaceLastMessage});
}

class ListenWorkspaceLastMessageEvent extends WorkspaceEvent {}

class PinWorkspaceEvent extends WorkspaceEvent {
  final int indexWorkspace;

  PinWorkspaceEvent({required this.indexWorkspace});
}

class MuteWorkspaceEvent extends WorkspaceEvent {
  final int indexWorkspace;

  MuteWorkspaceEvent({required this.indexWorkspace});
}

class SeenWorkspaceEvent extends WorkspaceEvent {
  final int indexWorkspace;

  SeenWorkspaceEvent({required this.indexWorkspace});
}
