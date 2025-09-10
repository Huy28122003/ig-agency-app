import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/dependencies/media/media_manager.dart';
import 'package:ig_agency_app/dependencies/permission/permission_manager.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/shared/utils/logger.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/commons/enums/status.dart';
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

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<SaveMediaEvent>(_onSaveMedia);
    handleSubEvent<SendMediaEvent>(_onSendMedia);
    handleSubEvent<EditMediaEvent>(_onEditMedia);
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
}
