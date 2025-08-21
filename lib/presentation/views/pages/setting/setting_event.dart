part of 'setting_bloc.dart';

sealed class SettingEvent {
  const SettingEvent();
}

class LoadDataEvent extends SettingEvent {
  const LoadDataEvent();
}
