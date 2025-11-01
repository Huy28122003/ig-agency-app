import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

abstract class MediaManager {
  Future<XFile?> pickMedia();

  Future<XFile?> pickPhoto();

  Future<bool> saveMediaByBoundary(GlobalKey key);

  Future<bool> saveMediaToLib(String path);

  Future<bool> saveNetworkImage(String path);

  Future<bool> saveVideoFromUrl(String url);

  Future<bool> openFileFromUrl(String url);

  Future<bool> openWebFromUrl(String url);
}
