part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class LoadDataEvent extends ProfileEvent {
  const LoadDataEvent();
}

class DeleteAccountEvent extends ProfileEvent {
  const DeleteAccountEvent();
}
