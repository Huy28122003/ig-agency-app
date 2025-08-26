part of 'workspace_bloc.dart';

sealed class WorkspaceEvent {}

class LoadDataEvent extends WorkspaceEvent {}

class RefreshDataEvent extends WorkspaceEvent {}

class LoadMoreDataEvent extends WorkspaceEvent{}
