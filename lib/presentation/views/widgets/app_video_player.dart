import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer({
    super.key,
    required this.path,
    this.controller,
    this.isNetworkUri = false,
    this.isAutoPlay = false,
    this.isPlayBack = true,
  });

  final String path;
  final bool isNetworkUri;
  final VideoPlayerController? controller;
  final bool isAutoPlay;
  final bool isPlayBack;

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoPlayOption = VideoPlayerOptions();
    _controller = widget.controller ?? _getDefaultController(videoPlayOption);
    _controller.setLooping(widget.isPlayBack);
    _controller.initialize().then((_) {
      setState(() {});
      if (widget.isAutoPlay) _controller.play();
    });
  }

  VideoPlayerController _getDefaultController(VideoPlayerOptions options) {
    if (widget.isNetworkUri) {
      return VideoPlayerController.networkUrl(
        Uri(path: widget.path),
        videoPlayerOptions: options,
      );
    }

    return VideoPlayerController.file(
      File(widget.path),
      videoPlayerOptions: options,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
