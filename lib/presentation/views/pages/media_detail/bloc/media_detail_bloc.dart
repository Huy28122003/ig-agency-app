import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/media_entity.dart';
import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:ig_agency_app/shared/utils/download_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:video_player/video_player.dart';

import '../../../../../shared/commons/enums/status.dart';

part 'media_detail_event.dart';

part 'media_detail_state.dart';

@injectable
class MediaDetailBloc extends BaseBloc<MediaDetailEvent, MediaDetailState> {
  late final List<MediaEntity> medias;
  VideoPlayerController? videoPlayerController;
  late final PageController pageController;
  late final int initialImageIndex;

  MediaDetailBloc() : super(MediaDetailState()) {
    handleLoadData<LoadDataEvent>(_onLoadData);
    handleSubEvent<ChangeMediaEvent>(_onChangeMedia);
    handleSubEvent<DownloadMediaEvent>(_onDownloadMedia);
    handleSubEvent<LoadVideoEvent>(_onLoadVideo);
    handleSubEvent<ToggleVideoEvent>(_onToggleVideo);
    handleSubEvent<ChangeImageViewModeEvent>(_onChangeImageViewMode);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<MediaDetailState> emit,
  ) async {
    pageController = PageController(initialPage: initialImageIndex);
    if (medias[initialImageIndex].isVideo) {
      add(LoadVideoEvent(index: initialImageIndex));
    }
    emit(
      state.copyWith(
        pageStatus: PageStatus.loaded,
        imageIndex: initialImageIndex,
      ),
    );
  }

  Future<void> _onChangeMedia(
    ChangeMediaEvent event,
    Emitter<MediaDetailState> emit,
  ) async {
    if (videoPlayerController != null) {
      videoPlayerController?.dispose();
      videoPlayerController = null;
    }
    emit(
      state.copyWith(
        imageIndex: event.index,
        loadVideoStatus: PageStatus.initial,
        isPlaying: false,
      ),
    );
  }

  Future<void> _onDownloadMedia(
    DownloadMediaEvent event,
    Emitter<MediaDetailState> emit,
  ) async {
    bool result = false;
    final currentMedia = medias[state.imageIndex];
    if (currentMedia.isVideo) {
      result = await DownloadUtils.saveVideoFromUrl("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4");
      // result = await DownloadUtils.saveVideoFromUrl(currentMedia.previewUrl);
    } else {
      result = await DownloadUtils.saveImageFromUrl(currentMedia.previewUrl);
    }

    emit(state.copyWith(isDownloadSuccess: result));
  }

  Future<void> _onLoadVideo(
    LoadVideoEvent event,
    Emitter<MediaDetailState> emit,
  ) async {
    emit(state.copyWith(loadVideoStatus: PageStatus.loading));

    videoPlayerController?.dispose();

    final data = medias[event.index];
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        // data.previewUrl,
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      ),
    );

    await videoPlayerController?.initialize();
    emit(state.copyWith(loadVideoStatus: PageStatus.loaded));
  }

  Future<void> _onToggleVideo(
    ToggleVideoEvent event,
    Emitter<MediaDetailState> emit,
  ) async {
    if (state.isPlaying) {
      videoPlayerController?.pause();
    } else {
      videoPlayerController?.play();
    }
    emit(state.copyWith(isPlaying: !state.isPlaying));
  }

  Future<void> _onChangeImageViewMode(
    ChangeImageViewModeEvent event,
    Emitter<MediaDetailState> emit,
  ) async {
    emit(state.copyWith(isFullScreenMode: !state.isFullScreenMode));
  }
}
