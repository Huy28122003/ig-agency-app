part of 'media_detail_bloc.dart';

class MediaDetailEvent {}

class LoadDataEvent extends MediaDetailEvent {}

class DownloadMediaEvent extends MediaDetailEvent {}

class LoadVideoEvent extends MediaDetailEvent {
  final int index;

  LoadVideoEvent({required this.index});
}

class ToggleVideoEvent extends MediaDetailEvent {}

class SeekVideoEvent extends MediaDetailEvent {}

class ChangeImageViewModeEvent extends MediaDetailEvent{}

class ChangeMediaEvent extends MediaDetailEvent{
  final int index;

  ChangeMediaEvent({required this.index});

}
