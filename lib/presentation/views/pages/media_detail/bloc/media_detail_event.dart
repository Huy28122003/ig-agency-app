part of 'media_detail_bloc.dart';

class MediaDetailEvent {}

class LoadDataEvent extends MediaDetailEvent {}

class DownloadMediaEvent extends MediaDetailEvent {}

class LoadVideoEvent extends MediaDetailEvent {}

class ToggleVideoEvent extends MediaDetailEvent {}

class SeekVideoEvent extends MediaDetailEvent {}

class ChangeImageViewModeEvent extends MediaDetailEvent{}
