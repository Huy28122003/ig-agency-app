part of 'media_preview_bloc.dart';

sealed class MediaPreviewEvent {}

class LoadDataEvent extends MediaPreviewEvent {}

class SendMediaEvent extends MediaPreviewEvent {}

class CropAvatarEvent extends MediaPreviewEvent {
  CropAvatarEvent({
    required this.circleRadius,
    required this.imageWidth,
    required this.imageHeight,
  });

  final double circleRadius;
  final double imageWidth;
  final double imageHeight;
}

class SaveMediaEvent extends MediaPreviewEvent {}

class EditMediaEvent extends MediaPreviewEvent {}
