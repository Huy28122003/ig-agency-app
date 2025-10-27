import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/dependencies/media/media_manager.dart';
import 'package:ig_agency_app/dependencies/permission/permission_manager.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/shared/commons/enums/permission.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'camera_event.dart';

part 'camera_state.dart';

@injectable
class CameraBloc extends BaseBloc<CameraEvent, CameraState> {
  CameraBloc(this._permissionManager, this._mediaManager)
    : super(CameraState()) {
    _registerHandlers();
  }

  late final String groupId;

  final MediaManager _mediaManager;
  final PermissionManager _permissionManager;
  CameraController? _cameraController;
  AppLifecycleState? _oldLifecycleState;
  List<CameraDescription> _cameras = [];

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<ReverseCameraEvent>(_onReverseCamera);
    handleSubEvent<ChangeFlashEvent>(_onChangeFlash);
    handleSubEvent<TakePhotoEvent>(_onTakePhoto);
    handleSubEvent<StartRecordEvent>(_onStartRecord);
    handleSubEvent<StopRecordEvent>(_onStopRecord);
    handleSubEvent<PickMediaEvent>(_onPickMediaEvent);
    handleSubEvent<AppLifecycleChangedEvent>(_onAppLifecycleChangedEvent);
  }

  CameraController? get controller => _cameraController;

  CameraDescription get _description =>
      _cameras.length > 1 ? _cameras[state.isFontCamera ? 1 : 0] : _cameras[0];

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      await _cameraController?.dispose();
      _cameraController = null;

      /// Get available cameras
      _cameras = await availableCameras();

      /// Request permission, setup camera when the user granted
      final permission = await _permissionManager.checkCameraPermission();
      await _permissionManager.checkMicroPermission();
      if (permission.isGranted && _cameras.isNotEmpty) {
        _cameraController = CameraController(
          _description,
          ResolutionPreset.high,
        );
        await _cameraController?.initialize();
        await _cameraController?.setFlashMode(
          state.isFlashEnabled ? FlashMode.auto : FlashMode.off,
        );
      }
      emit(
        state.copyWith(
          pageStatus: PageStatus.loaded,
          status: permission.isGranted
              ? CameraStatus.ready
              : CameraStatus.notAvailable,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          pageStatus: PageStatus.loaded,
          status: CameraStatus.notAvailable,
        ),
      );
    }
  }

  Future<void> _onReverseCamera(
    ReverseCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    emit(state.copyWith(isFontCamera: !state.isFontCamera));
    if (_cameras.isNotEmpty && state.status.isReady) {
      _cameraController?.setDescription(_description);
    }
  }

  Future<void> _onChangeFlash(
    ChangeFlashEvent event,
    Emitter<CameraState> emit,
  ) async {
    final currentState = state.isFlashEnabled;
    try {
      if (_cameras.isNotEmpty && state.status.isReady) {
        await _cameraController?.setFlashMode(
          !currentState ? FlashMode.auto : FlashMode.off,
        );
      }
      emit(state.copyWith(isFlashEnabled: !currentState));
    } catch (e) {
      return;
    }
  }

  Future<void> _onTakePhoto(
    TakePhotoEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      if (!state.status.isReady) return;
      emit(state.copyWith(media: ''));
      if (_cameraController?.value.isInitialized != true) return;
      final file = await _cameraController?.takePicture();
      emit(state.copyWith(media: file?.path ?? '', isPhoto: true));
    } catch (e) {
      return;
    }
  }

  Future<void> _onStartRecord(
    StartRecordEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      if (!state.status.isReady) return;
      await _cameraController?.startVideoRecording();
      emit(state.copyWith(inProgress: true));
    } catch (e) {
      emit(state.copyWith(inProgress: false));
    }
  }

  Future<void> _onStopRecord(
    StopRecordEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      if (!state.status.isReady) return;
      emit(state.copyWith(inProgress: false));
      final file = await _cameraController?.stopVideoRecording();
      await Future.delayed(Duration(milliseconds: 250));
      emit(state.copyWith(media: file?.path ?? '', isPhoto: false));
    } catch (e) {
      emit(state.copyWith(inProgress: true));
    }
  }

  Future<void> _onPickMediaEvent(
    PickMediaEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      emit(state.copyWith(media: ''));
      final result = await _mediaManager.pickMedia();
      if (result == null) return;
      bool? isPhoto;

      if (result.path.isImage()) isPhoto = true;
      if (result.path.isVideo()) isPhoto = false;
      if (isPhoto == null) return;
      emit(state.copyWith(isPhoto: isPhoto, media: result.path));
    } catch (e) {
      return;
    }
  }

  Future<void> _onAppLifecycleChangedEvent(
    AppLifecycleChangedEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state.status.isInitial) return;
    final newState = event.state;
    if (newState == AppLifecycleState.inactive &&
        newState != _oldLifecycleState) {
      _oldLifecycleState = newState;
      emit(state.copyWith(status: CameraStatus.dispose));
      await _cameraController?.dispose();
      _cameraController = null;
    }
    if (event.state == AppLifecycleState.resumed &&
        _oldLifecycleState == AppLifecycleState.inactive &&
        _cameraController?.value.isInitialized != true) {
      _oldLifecycleState = newState;
      add(LoadDataEvent());
    }
  }

  @override
  Future<void> close() async {
    await _cameraController?.dispose();
    return super.close();
  }
}
