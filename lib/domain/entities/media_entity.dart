class MediaEntity {
  final int id;
  final bool isVideo;
  final String previewUrl;
  final Duration? duration;

  MediaEntity({
    required this.id,
    required this.isVideo,
    required this.previewUrl,
    this.duration,
  });
}
