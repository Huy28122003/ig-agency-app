part of 'login_history_bloc.dart';

sealed class LoginHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDataEvent extends LoginHistoryEvent {
  LoadDataEvent();
}

class SelectAllDeviceEvent extends LoginHistoryEvent {
  SelectAllDeviceEvent();
}

class SelectDeviceEvent extends LoginHistoryEvent {
  final LinkedDeviceEntity device;
  SelectDeviceEvent(this.device);
  @override
  List<Object?> get props => [device];
}

class LogoutEvent extends LoginHistoryEvent {
  LogoutEvent();
}
