part of 'camera_bloc.dart';

class CameraState extends BaseState<CameraState> {
  const CameraState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.isFontCamera = false,
    this.isFlashEnabled = false,
    this.inProgress = false,
    this.status = CameraStatus.initial,
    this.media = '',
    this.isPhoto = true,
  });

  final bool isFontCamera;
  final bool isFlashEnabled;
  final bool inProgress;
  final String media;
  final CameraStatus status;
  final bool isPhoto;

  @override
  CameraState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    bool? isFontCamera,
    bool? inProgress,
    bool? isFlashEnabled,
    String? media,
    CameraStatus? status,
    bool? isPhoto,
  }) {
    return CameraState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      inProgress: inProgress ?? this.inProgress,
      isFontCamera: isFontCamera ?? this.isFontCamera,
      isFlashEnabled: isFlashEnabled ?? this.isFlashEnabled,
      media: media ?? this.media,
      status: status ?? this.status,
      isPhoto: isPhoto ?? this.isPhoto,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    isFontCamera,
    inProgress,
    isFlashEnabled,
    media,
    status,
    isPhoto,
  ];
}
