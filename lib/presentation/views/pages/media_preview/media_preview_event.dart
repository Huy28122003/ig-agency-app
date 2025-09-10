part of 'media_preview_bloc.dart';

sealed class MediaPreviewEvent {}

class LoadDataEvent extends MediaPreviewEvent {
  final String avatar;
  final String mediaPath;

  LoadDataEvent(this.avatar, this.mediaPath);
}

class SendMediaEvent extends MediaPreviewEvent {}

class SaveMediaEvent extends MediaPreviewEvent {}
