part of 'edit_bio_bloc.dart';

sealed class EditBioEvent {
  const EditBioEvent();
}

class LoadDataEvent extends EditBioEvent {
  const LoadDataEvent();
}

class BioChangedEvent extends EditBioEvent {
  const BioChangedEvent(this.bio);

  final String bio;
}

class SaveBioEvent extends EditBioEvent {
  const SaveBioEvent();
}
