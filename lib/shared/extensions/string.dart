import 'package:path/path.dart' as path;

import '../../flavor_settings.dart';

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

extension BaseUrlExtension on String {
  String withBaseUrl() {
    if (startsWith('http')) return this;
    return FlavorSettings().baseUrl + this;
  }
}
