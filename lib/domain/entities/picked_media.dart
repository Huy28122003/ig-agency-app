enum PickedMediaType {
  image,
  video,
  other;

  bool get isImage => this == PickedMediaType.image;
  bool get isVideo => this == PickedMediaType.video;
}

class PickedMedia {
  final String path;
  final String? mimeType;
  final PickedMediaType type;

  PickedMedia({required this.path, required this.mimeType})
    : type = _getTypeFromXFile(mimeType);

  static PickedMediaType _getTypeFromXFile(String? mimeType) {
    if (mimeType == null) {
      return PickedMediaType.other;
    }
    if (mimeType.startsWith('image/')) {
      return PickedMediaType.image;
    } else if (mimeType.startsWith('video/')) {
      return PickedMediaType.video;
    } else {
      return PickedMediaType.other;
    }
  }
}
