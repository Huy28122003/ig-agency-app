enum MediaUseCase {
  sendMessage,
  updateAvatar;

  bool get isCaptureOnly => this == updateAvatar;
}
