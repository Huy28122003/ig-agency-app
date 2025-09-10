import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/dependencies/media/media_manager.dart';
import 'package:ig_agency_app/dependencies/permission/permission_manager.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/shared/utils/logger.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'media_edit_event.dart';

part 'media_edit_state.dart';

@injectable
class MediaEditBloc extends BaseBloc<MediaEditEvent, MediaEditState> {
  MediaEditBloc(this._mediaManager, this._permissionManager)
    : super(MediaEditState()) {
    _registerHandlers();
  }

  final MediaManager _mediaManager;
  final PermissionManager _permissionManager;
  late String path;
  late bool isPhoto;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<SaveMediaEvent>(_onSaveMedia);
    handleSubEvent<SendMediaEvent>(_onSendMedia);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<MediaEditState> emit,
  ) async {}

  Future<void> _onSaveMedia(
    SaveMediaEvent event,
    Emitter<MediaEditState> emit,
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
    Emitter<MediaEditState> emit,
  ) async {}
}
