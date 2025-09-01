part of 'edit_name_bloc.dart';

sealed class EditNameEvent {
  const EditNameEvent();
}

class LoadDataEvent extends EditNameEvent {
  const LoadDataEvent();
}

class NameChangedEvent extends EditNameEvent {
  const NameChangedEvent(this.name);

  final String name;
}

class SaveNameEvent extends EditNameEvent {
  const SaveNameEvent();
}
