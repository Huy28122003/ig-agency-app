part of 'camera_bloc.dart';

sealed class CameraEvent {
  const CameraEvent();
}

class LoadDataEvent extends CameraEvent {}

class ReverseCameraEvent extends CameraEvent {}

class ChangeFlashEvent extends CameraEvent {}

class TakePhotoEvent extends CameraEvent {}

class StartRecordEvent extends CameraEvent {}

class StopRecordEvent extends CameraEvent {}

class PauseRecordEvent extends CameraEvent {}

class ResumRecordEvent extends CameraEvent {}

class PickMediaEvent extends CameraEvent {}

class AppLifecycleChangedEvent extends CameraEvent {
  final AppLifecycleState state;

  AppLifecycleChangedEvent(this.state);
}
