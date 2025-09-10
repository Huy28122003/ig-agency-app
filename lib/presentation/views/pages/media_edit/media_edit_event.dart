part of 'media_edit_bloc.dart';

sealed class MediaEditEvent {}

class LoadDataEvent extends MediaEditEvent {
  final String mediaPath;

  LoadDataEvent(this.mediaPath);
}

class SendMediaEvent extends MediaEditEvent {}

class SaveMediaEvent extends MediaEditEvent {}
