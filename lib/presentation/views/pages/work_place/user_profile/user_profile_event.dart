part of 'user_profile_bloc.dart';

sealed class UserProfileEvent {
  const UserProfileEvent();
}

class LoadDataEvent extends UserProfileEvent {
  const LoadDataEvent();
}
