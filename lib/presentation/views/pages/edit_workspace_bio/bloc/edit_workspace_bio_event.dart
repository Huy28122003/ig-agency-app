part of 'edit_workspace_bio_bloc.dart';

class EditWorkspaceBioEvent {}

class LoadDataEvent extends EditWorkspaceBioEvent {
  final String bio;
  final int workspaceId;

  LoadDataEvent({required this.bio, required this.workspaceId});
}

class BioChangeEvent extends EditWorkspaceBioEvent {
  final String value;

  BioChangeEvent({required this.value});
}

class SubmitBioEvent extends EditWorkspaceBioEvent {}
