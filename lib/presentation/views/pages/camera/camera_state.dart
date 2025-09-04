part of 'camera_bloc.dart';

class CameraState extends BaseState<CameraState> {
  const CameraState({
    super.pageStatus = PageStatus.loaded,
    super.pageErrorMessage,
    super.processing = false,
    this.isFontCamera = false,
    this.isFlashEnabled = false,
    this.status = CameraStatus.initial,
    this.isCompleted = false,
    this.cameras = const [],
  });

  final bool isFontCamera;
  final bool isFlashEnabled;
  final bool isCompleted;
  final CameraStatus status;
  final List<CameraDescription> cameras;

  @override
  CameraState copyWith({
    PageStatus? pageStatus,
    String? pageErrorMessage,
    bool? processing,
    bool? isFontCamera,
    bool? isFlashEnabled,
    bool? isCompleted,
    CameraStatus? status,
    List<CameraDescription>? cameras,
  }) {
    return CameraState(
      pageStatus: pageStatus ?? this.pageStatus,
      pageErrorMessage: pageErrorMessage ?? this.pageErrorMessage,
      processing: processing ?? this.processing,
      isFontCamera: isFontCamera ?? this.isFontCamera,
      isFlashEnabled: isFlashEnabled ?? this.isFlashEnabled,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? this.status,
      cameras: cameras ?? this.cameras,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    isFontCamera,
    isFlashEnabled,
    isCompleted,
    status,
    cameras,
  ];
}
