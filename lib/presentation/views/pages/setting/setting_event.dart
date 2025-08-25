part of 'setting_bloc.dart';

sealed class SettingEvent {
  const SettingEvent();
}

class LoadDataEvent extends SettingEvent {
  const LoadDataEvent();
}

class LogoutEvent extends SettingEvent {
  const LogoutEvent();
}

class ToggleDarkModeEvent extends SettingEvent {
  const ToggleDarkModeEvent();
}

class ToggleInAppAlertsEvent extends SettingEvent {
  const ToggleInAppAlertsEvent();
}
