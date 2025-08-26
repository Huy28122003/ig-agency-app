part of 'setting_home_bloc.dart';

sealed class SettingHomeEvent {
  const SettingHomeEvent();
}

class LoadDataEvent extends SettingHomeEvent {
  const LoadDataEvent();
}
