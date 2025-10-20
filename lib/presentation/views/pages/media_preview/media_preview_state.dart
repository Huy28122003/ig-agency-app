part of 'media_preview_bloc.dart';

class MediaPreviewState extends BaseState<MediaPreviewState> {
  const MediaPreviewState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.path = '',
    this.isCropSuccess = false,
  });

  final String path;
  final bool isCropSuccess;

  @override
  MediaPreviewState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    String? path,
    bool? isCropSuccess,
  }) {
    return MediaPreviewState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      path: path ?? this.path,
      isCropSuccess: isCropSuccess ?? this.isCropSuccess,
    );
  }

  @override
  List<Object?> get props => [...super.props, path, isCropSuccess];
}
