part of 'linked_device_bloc.dart';

sealed class LinkedDeviceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDataEvent extends LinkedDeviceEvent {
  LoadDataEvent();
}
