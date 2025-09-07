import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/commons/enums/status.dart';
import '../../../base/base_state.dart';

part 'media_preview_event.dart';

part 'media_preview_state.dart';

@injectable
class MediaPreviewBloc extends BaseBloc<MediaPreviewEvent, MediaPreviewState> {
  MediaPreviewBloc() : super(MediaPreviewState()) {
    _registerHandlers();
  }

  late String path;
  late String avatar;
  late bool isPhoto;

  void _registerHandlers() {
    handleLoadData<LoadDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<MediaPreviewState> emit,
  ) async {}

  // Future<void> _onReverseCamera(
  //   ReverseCameraEvent event,
  //   Emitter<MediaPreviewState> emit,
  // ) async {}
}
