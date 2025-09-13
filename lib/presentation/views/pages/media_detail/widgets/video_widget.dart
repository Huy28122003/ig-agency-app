import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/pages/media_detail/bloc/media_detail_bloc.dart';
import 'package:ig_agency_app/shared/commons/enums/status.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({super.key});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late final MediaDetailBloc _mediaDetailBloc;

  @override
  void initState() {
    super.initState();
    _mediaDetailBloc = context.read<MediaDetailBloc>();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: BlocSelector<MediaDetailBloc, MediaDetailState, PageStatus>(
        selector: (state) {
          return state.loadVideoStatus;
        },
        builder: (context, state) {
          if (state.isLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio:
                      _mediaDetailBloc.videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_mediaDetailBloc.videoPlayerController),
                ),
                SizedBox(height: 20),
                VideoProgressIndicator(
                  _mediaDetailBloc.videoPlayerController,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: AppColors.surfaceContainerPrimaryPrimaryDefault,
                    bufferedColor:
                        AppColors.surfaceContainerPrimaryPrimaryDisabled,
                    backgroundColor: AppColors.surfaceContainerGrayStrong2,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Spacer(),
                    ValueListenableBuilder<VideoPlayerValue>(
                      valueListenable: _mediaDetailBloc.videoPlayerController,
                      builder: (context, value, child) {
                        final position = value.position;
                        final duration = value.duration;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "${_formatDuration(position)} / ${_formatDuration(duration)}",
                            style: TextStyle(
                              color: AppColors.textDefaultTextDefault,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: FontFamily.segoeUI,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                BlocSelector<MediaDetailBloc, MediaDetailState, bool>(
                  selector: (state) {
                    return state.isPlaying;
                  },
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () {
                        _mediaDetailBloc.add(ToggleVideoEvent());
                      },
                      icon: (state)
                          ? Icon(Icons.pause, color: AppColors.primary, size: 40)
                          : Icon(
                              Icons.play_arrow_rounded,
                              color: AppColors.primary,
                              size: 40,
                            ),
                    );
                  },
                ),
              ],
            );
          } else if (state.isLoading) {
            return Center(child: CupertinoActivityIndicator());
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
