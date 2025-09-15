import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:ig_agency_app/dependencies/media/media_manager.dart';
import 'package:ig_agency_app/shared/utils/logger.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

@Injectable(as: MediaManager)
class MediaPickerImpl extends MediaManager {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<XFile?> pickMedia() async {
    try {
      return await _imagePicker.pickMedia();
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<bool> saveMediaByBoundary(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await (image.toByteData(
        format: ui.ImageByteFormat.png,
      ));
      await ImageGallerySaverPlus.saveImage(byteData!.buffer.asUint8List());
      return true;
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return false;
    }
  }

  @override
  Future<bool> saveMediaToLib(String path) async {
    try {
      await ImageGallerySaverPlus.saveFile(path);
      return true;
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return false;
    }
  }

  @override
  Future<bool> saveNetworkImage(String path) async {
    try {
      var response = await Dio().get(
        path,
        options: Options(responseType: ResponseType.bytes),
      );
      await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: '${DateTime.now().millisecondsSinceEpoch}',
      );
      return true;
    } catch (e, s) {
      logger.e(e, stackTrace: s);
      return false;
    }
  }

  @override
  Future<bool> saveVideoFromUrl(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath =
          "${tempDir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4";
      final file = File(tempPath);

      final response = await Dio().download(
        url,
        file.path,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
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

  @override
  Future<bool> openFileFromUrl(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final name = url.split('/').last;
      final savePath = "${tempDir.path}/$name";

      final response = await Dio().download(url, savePath);
      if (response.statusCode == 200) {
        final result = await OpenFilex.open(savePath);
        return result.type == ResultType.done;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> openWebFromUrl(String url) async {
    try {
      final path = Uri.parse(url);
      if (await canLaunchUrl(path)) {
        final result = await launchUrl(
          path,
          mode: LaunchMode.externalApplication,
        );
        return result;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
