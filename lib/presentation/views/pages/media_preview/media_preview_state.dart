part of 'media_preview_bloc.dart';

class MediaPreviewState extends BaseState<MediaPreviewState> {
  const MediaPreviewState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.path = '',
  });

  final String path;

  @override
  MediaPreviewState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? path,
  }) {
    return MediaPreviewState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      path: path ?? this.path,
    );
  }

  @override
  List<Object?> get props => [...super.props, path];
}
