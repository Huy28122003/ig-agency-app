import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
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

extension BaseUrlExtension on String? {
  String withBaseUrl() {
    if (this == null || this!.isEmpty) {
      return '';
    }
    return '${FlavorSettings().baseUrl}/$this';
  }
}

extension MultipartFilePathExt on String? {
  Future<MultipartFile?> toMultipartFile() async {
    final pathFile = this;
    if (pathFile == null) return null;

    final file = File(pathFile);
    final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
    final mime = mimeType.split('/');

    return await MultipartFile.fromFile(
      file.path,
      filename: path.basename(file.path),
      contentType: MediaType(mime[0], mime[1]),
    );
  }
}
