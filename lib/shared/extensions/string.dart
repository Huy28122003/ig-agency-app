import 'package:path/path.dart' as path;

extension PathFileExtension on String {
  bool isImage() {
    final ext = path.extension(this).toLowerCase();
    return [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
      '.heic',
      '.heif',
    ].contains(ext);
  }

  bool isVideo() {
    final ext = path.extension(this).toLowerCase();
    return [
      '.mp4',
      '.mov',
      '.avi',
      '.mkv',
      '.3gp',
      '.flv',
      '.wmv',
    ].contains(ext);
  }
}

extension StringNullableExtension on String? {
  bool isNullOrEmpty() {
    return (this ?? '').isEmpty;
  }

  bool isNotNullOrEmpty() {
    return (this ?? '').isNotEmpty;
  }
}
