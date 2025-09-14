part of 'members_bloc.dart';

class MembersEvent {}

class LoadDataEvent extends MembersEvent {
  final int workspaceId;

  LoadDataEvent({required this.workspaceId});
}

class GetDataEvent extends MembersEvent {}

class RefreshDataEvent extends MembersEvent{}
