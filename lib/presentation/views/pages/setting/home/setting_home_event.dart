part of 'setting_home_bloc.dart';

sealed class SettingHomeEvent {
  const SettingHomeEvent();
}

class LoadDataEvent extends SettingHomeEvent {
  const LoadDataEvent();
}

class LogoutEvent extends SettingHomeEvent {
  const LogoutEvent();
}

class ToggleDarkModeEvent extends SettingHomeEvent {
  const ToggleDarkModeEvent();
}

class ToggleNotificationEvent extends SettingHomeEvent {
  const ToggleNotificationEvent();
}

class UpdateUserEvent extends SettingHomeEvent {
  const UpdateUserEvent({required this.user});

  final ProfileInfoEntity user;
}
