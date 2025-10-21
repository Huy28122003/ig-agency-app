part of 'edit_group_bio_bloc.dart';

class EditGroupBioEvent {}

class LoadDataEvent extends EditGroupBioEvent {
  final String bio;
  final String workspaceId;

  LoadDataEvent({required this.bio, required this.workspaceId});
}

class BioChangeEvent extends EditGroupBioEvent {
  final String value;

  BioChangeEvent({required this.value});
}

class SubmitBioEvent extends EditGroupBioEvent {}
