part of 'workspace_detail_bloc.dart';

sealed class WorkspaceDetailEvent {
  const WorkspaceDetailEvent();
}

class LoadDataEvent extends WorkspaceDetailEvent {
  const LoadDataEvent();
}
