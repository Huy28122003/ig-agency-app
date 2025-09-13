import 'package:ig_agency_app/presentation/base/base_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_state.dart';
import 'package:injectable/injectable.dart';
import 'package:video_player/video_player.dart';

import '../../../../../shared/commons/enums/status.dart';

part 'media_detail_event.dart';

part 'media_detail_state.dart';

@injectable
class MediaDetailBloc extends BaseBloc<MediaDetailEvent, MediaDetailState> {
  late final String url;
  late final bool isVideo;
  late final VideoPlayerController videoPlayerController;

  MediaDetailBloc() : super(MediaDetailState()) {
    handleLoadData<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(pageStatus: PageStatus.loaded));
      add(LoadVideoEvent());
    });
    handleSubEvent<DownloadMediaEvent>((event, emit) async {
      //todo: demo vi chua lam dc xin quyen ios
      // var response = await Dio().get(
      //   url,
      //   options: Options(responseType: ResponseType.bytes),
      // );
      // final result = await ImageGallerySaver.saveImage(
      //   Uint8List.fromList(response.data),
      //   quality: 60,
      //   name: DateTime.now().toString(),
      // );
      emit(state.copyWith(isDownloadSuccess: true));
    });

    handleSubEvent<LoadVideoEvent>((event, emit) async {
      emit(state.copyWith(loadVideoStatus: PageStatus.loading));

      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        ),
      );

      await videoPlayerController.initialize();

      emit(state.copyWith(loadVideoStatus: PageStatus.loaded));
    });

    handleSubEvent<ToggleVideoEvent>((event, emit) async {
      if (state.isPlaying) {
        videoPlayerController.pause();
      } else {
        videoPlayerController.play();
      }
      emit(state.copyWith(isPlaying: !state.isPlaying));
    });
    handleSubEvent<ChangeImageViewModeEvent>((event, emit) async {
      emit(state.copyWith(isFullScreenMode: !state.isFullScreenMode));
    });
  }
}
