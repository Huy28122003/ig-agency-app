part of 'media_detail_bloc.dart';

class MediaDetailState extends BaseState<MediaDetailState> {
  const MediaDetailState({
    super.pageStatus = PageStatus.initial,
    super.pageErrorMessage = '',
    super.processing = false,
    this.isDownloadSuccess = false,
    this.loadVideoStatus = PageStatus.initial,
    this.isPlaying = false,
    this.isFullScreenMode = false,
  });

  final bool isDownloadSuccess;
  final PageStatus loadVideoStatus;
  final bool isPlaying;
  final bool isFullScreenMode;

  @override
  MediaDetailState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    bool? isDownloadSuccess,
    bool? isPlaying,
    bool? isFullScreenMode,
    PageStatus? loadVideoStatus,
  }) {
    return MediaDetailState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      isDownloadSuccess: isDownloadSuccess ?? this.isDownloadSuccess,
      isPlaying: isPlaying ?? this.isPlaying,
      loadVideoStatus: loadVideoStatus ?? this.loadVideoStatus,
      isFullScreenMode: isFullScreenMode ?? this.isFullScreenMode,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    isDownloadSuccess,
    loadVideoStatus,
    isFullScreenMode,
    isPlaying,
  ];
}
