part of 'edit_workspace_bio_bloc.dart';

class EditWorkspaceNameEvent {}

class LoadDataEvent extends EditWorkspaceNameEvent {
  final String bio;
  final int workspaceId;

  LoadDataEvent({required this.bio, required this.workspaceId});
}

class BioChangeEvent extends EditWorkspaceNameEvent {
  final String value;

  BioChangeEvent({required this.value});
}

class SubmitBioEvent extends EditWorkspaceNameEvent {}
