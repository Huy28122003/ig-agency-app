part of 'media_preview_bloc.dart';

sealed class MediaPreviewEvent {
  const MediaPreviewEvent();
}

class LoadDataEvent extends MediaPreviewEvent {
  final String avatar;
  final String mediaPath;

  LoadDataEvent(this.avatar, this.mediaPath);
}
