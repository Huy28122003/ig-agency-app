part of 'media_preview_bloc.dart';

sealed class MediaPreviewEvent {}

class LoadDataEvent extends MediaPreviewEvent {}

class ConfirmEvent extends MediaPreviewEvent {}

class SaveMediaEvent extends MediaPreviewEvent {}

class EditMediaEvent extends MediaPreviewEvent {}
