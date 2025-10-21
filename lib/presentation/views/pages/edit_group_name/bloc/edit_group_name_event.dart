part of 'edit_group_name_bloc.dart';

class EditGroupNameEvent {}

class LoadDataEvent extends EditGroupNameEvent {
  final String bio;
  final String workspaceId;

  LoadDataEvent({required this.bio, required this.workspaceId});
}

class BioChangeEvent extends EditGroupNameEvent {
  final String value;

  BioChangeEvent({required this.value});
}

class SubmitBioEvent extends EditGroupNameEvent {}
