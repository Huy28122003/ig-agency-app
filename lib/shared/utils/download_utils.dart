import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadUtils {
  static Future<bool> _requestPermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<bool> saveImageFromUrl(String url) async {
    try {
      if (!await _requestPermission()) return false;

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await ImageGallerySaverPlus.saveImage(
          Uint8List.fromList(response.bodyBytes),
          quality: 100,
          name: "agency_${DateTime.now().millisecondsSinceEpoch}",
        );
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<bool> saveVideoFromUrl(String url) async {
    try {
      if (!await _requestPermission()) return false;

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempPath =
            "${tempDir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4";
        final file = File(tempPath);
        await file.writeAsBytes(response.bodyBytes);

        await ImageGallerySaverPlus.saveFile(
          file.path,
          name: "agency_${DateTime.now().millisecondsSinceEpoch}.mp4",
        );
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
