part of 'device_detail_bloc.dart';

sealed class DeviceDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitDataEvent extends DeviceDetailEvent {
  final LinkedDeviceEntity device;

  InitDataEvent({required this.device});

  @override
  List<Object?> get props => [device];
}

class LoadDataEvent extends DeviceDetailEvent {
  LoadDataEvent();
}

class LogoutEvent extends DeviceDetailEvent {
  LogoutEvent();
}
