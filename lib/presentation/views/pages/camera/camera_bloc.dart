import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/dependencies/permission/permission_manager.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/shared/commons/enums/permission.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'camera_event.dart';

part 'camera_state.dart';

@injectable
class CameraBloc extends BaseBloc<CameraEvent, CameraState> {
  CameraBloc(this._permissionManager) : super(CameraState()) {
    _registerHandlers();
  }

  final PermissionManager _permissionManager;
  CameraController? _cameraController;
  AppLifecycleState? _oldLifecycleState;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<ReverseCameraEvent>(_onReverseCamera);
    handleSubEvent<ChangeFlashEvent>(_onChangeFlash);
    handleSubEvent<TakePhotoEvent>(_onTakePhoto);
    handleSubEvent<StartRecordEvent>(_onStartRecord);
    handleSubEvent<StopRecordEvent>(_oStopRecord);
    handleSubEvent<AppLifecycleChangedEvent>(_onAppLifecycleChangedEvent);
  }

  CameraController? get controller => _cameraController;

  CameraDescription get _description => state.cameras.length > 1
      ? state.cameras[state.isFontCamera ? 0 : 1]
      : state.cameras[0];

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<CameraState> emit,
  ) async {
    List<CameraDescription> cameras = [];
    try {
      /// Get available cameras
      cameras = await availableCameras();

      /// Request permission, setup camera when the user granted
      final permission = await _permissionManager.checkCameraPermission();
      await _permissionManager.checkMicroPermission();
      if (permission.isGranted && cameras.isNotEmpty) {
        _cameraController = null;
        _cameraController = CameraController(
          _description,
          ResolutionPreset.high,
        );
        await _cameraController?.initialize();
      }
      emit(
        state.copyWith(
          pageStatus: PageStatus.loaded,
          cameras: cameras,
          status: permission.isGranted
              ? CameraStatus.ready
              : CameraStatus.notAvailable,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          pageStatus: PageStatus.loaded,
          cameras: cameras,
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
    if (state.cameras.isNotEmpty && state.status.isReady) {
      _cameraController?.setDescription(_description);
    }
  }

  Future<void> _onChangeFlash(
    ChangeFlashEvent event,
    Emitter<CameraState> emit,
  ) async {
    emit(state.copyWith(isFlashEnabled: !state.isFlashEnabled));
    if (state.cameras.isNotEmpty && state.status.isReady) {
      _cameraController?.setFlashMode(
        state.isFlashEnabled ? FlashMode.auto : FlashMode.off,
      );
    }
  }

  Future<void> _onTakePhoto(
    TakePhotoEvent event,
    Emitter<CameraState> emit,
  ) async {
    final file = await _cameraController?.takePicture();
  }

  Future<void> _onStartRecord(
    StartRecordEvent event,
    Emitter<CameraState> emit,
  ) async {
    await _cameraController?.startVideoRecording();
  }

  Future<void> _oStopRecord(
    StopRecordEvent event,
    Emitter<CameraState> emit,
  ) async {
    final file = await _cameraController?.stopVideoRecording();
  }

  Future<void> _onAppLifecycleChangedEvent(
    AppLifecycleChangedEvent event,
    Emitter<CameraState> emit,
  ) async {
    final newState = event.state;
    if (newState == AppLifecycleState.inactive) {
      if (newState == _oldLifecycleState) return;
      _oldLifecycleState = newState;
      emit(state.copyWith(status: CameraStatus.initial));
      _cameraController?.dispose();
      _cameraController == null;
    }
    if (event.state == AppLifecycleState.resumed) {
      if (newState == _oldLifecycleState) return;
      _oldLifecycleState = newState;
      add(LoadDataEvent());
    }
  }
}
