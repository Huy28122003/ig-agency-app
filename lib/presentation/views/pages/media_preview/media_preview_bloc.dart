import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ig_agency_app/dependencies/media/media_manager.dart';
import 'package:ig_agency_app/dependencies/permission/permission_manager.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/shared/utils/logger.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../../shared/commons/enums/camera_mode.dart';
import '../../../base/base_state.dart';

part 'media_preview_event.dart';

part 'media_preview_state.dart';

@injectable
class MediaPreviewBloc extends BaseBloc<MediaPreviewEvent, MediaPreviewState> {
  MediaPreviewBloc(this._mediaManager, this._permissionManager)
    : super(MediaPreviewState()) {
    _registerHandlers();
  }

  final MediaManager _mediaManager;
  final PermissionManager _permissionManager;
  late String path;
  late String avatar;
  late bool isPhoto;
  late double aspectRatio;
  late CameraMode cameraMode;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<SaveMediaEvent>(_onSaveMedia);
    handleSubEvent<SendMediaEvent>(_onSendMedia);
    handleSubEvent<EditMediaEvent>(_onEditMedia);
    handleSubEvent<CropAvatarEvent>(_onCropAvatar);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<MediaPreviewState> emit,
  ) async {
    emit(state.copyWith(path: path));
  }

  Future<void> _onSaveMedia(
    SaveMediaEvent event,
    Emitter<MediaPreviewState> emit,
  ) async {
    try {
      await _permissionManager.checkSavingMedia();
      await _mediaManager.saveMediaToLib(path);
    } catch (e, s) {
      logger.e(s, stackTrace: s);
    }
  }

  Future<void> _onSendMedia(
    SendMediaEvent event,
    Emitter<MediaPreviewState> emit,
  ) async {}

  Future<void> _onEditMedia(
    EditMediaEvent event,
    Emitter<MediaPreviewState> emit,
  ) async {
    if (!isPhoto) return;
    try {
      final cropped = await ImageCropper().cropImage(
        sourcePath: path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            // toolbarColor: AppColors.primary,
            activeControlsWidgetColor: AppColors.primary,
            toolbarWidgetColor: AppColors.surfaceContainerGrayStrong95,
            // toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );

      final newPath = cropped?.path;
      if (newPath != null) {
        emit(state.copyWith(path: newPath));
      }
    } catch (e) {
      return;
    }
  }

  Future<void> _onCropAvatar(
    CropAvatarEvent event,
    Emitter<MediaPreviewState> emit,
  ) async {
    try {
      emit(state.copyWith(processing: true, isCropSuccess: false));

      final double circleDiameter = event.circleRadius * 2;
      final double circleX = (event.imageWidth - circleDiameter) / 2;
      final double circleY = (event.imageHeight - circleDiameter) / 2;
      final Rect cropRect = Rect.fromLTWH(
        circleX,
        circleY,
        circleDiameter,
        circleDiameter,
      );

      final imageFile = File(state.path);
      final originalImage = img.decodeImage(imageFile.readAsBytesSync());

      if (originalImage == null) {
        throw Exception('Could not decode image');
      }

      final double scaleX = originalImage.width / event.imageWidth;
      final double scaleY = originalImage.height / event.imageHeight;

      final cropX = (cropRect.left * scaleX).round();
      final cropY = (cropRect.top * scaleY).round();
      final cropWidth = (cropRect.width * scaleX).round();
      final cropHeight = (cropRect.height * scaleY).round();

      final croppedImage = img.copyCrop(
        originalImage,
        x: cropX,
        y: cropY,
        width: cropWidth,
        height: cropHeight,
      );

      final tempDir = await getTemporaryDirectory();
      final tempPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final croppedFile = await File(
        tempPath,
      ).writeAsBytes(img.encodePng(croppedImage));

      emit(
        state.copyWith(
          processing: false,
          isCropSuccess: true,
          path: croppedFile.path,
        ),
      );
    } catch (error) {
      handleError(emit, error);
    }
  }
}
