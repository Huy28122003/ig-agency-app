part of 'edit_group_name_bloc.dart';

class EditGroupNameEvent {}

class LoadDataEvent extends EditGroupNameEvent {
  final String bio;
  final String workspaceId;

  LoadDataEvent({required this.bio, required this.workspaceId});
}

class NameChangeEvent extends EditGroupNameEvent {
  final String value;

  NameChangeEvent({required this.value});
}

class SubmitNameEvent extends EditGroupNameEvent {}
