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

class ToggleInAppAlertsEvent extends SettingHomeEvent {
  const ToggleInAppAlertsEvent();
}
