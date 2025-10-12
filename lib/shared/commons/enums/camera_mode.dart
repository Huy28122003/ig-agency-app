enum CameraMode {
  sendMessage,
  updateAvatar;

  bool get isCaptureOnly => this == updateAvatar;
}
