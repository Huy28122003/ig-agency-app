part of 'workspace_list_bloc.dart';

sealed class WorkspaceListEvent {
  const WorkspaceListEvent();
}

class LoadDataEvent extends WorkspaceListEvent {
  const LoadDataEvent();
}
