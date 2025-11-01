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

class UpdateUserEvent extends ProfileEvent {
  const UpdateUserEvent({required this.user});

  final ProfileInfoEntity user;
}

class UpdateAvatarEvent extends ProfileEvent {
  const UpdateAvatarEvent(this.path);

  final String path;
}
