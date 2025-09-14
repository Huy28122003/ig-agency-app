import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

abstract class MediaManager {
  Future<XFile?> pickMedia();

  Future<bool> saveMediaByBoundary(GlobalKey key);

  Future<bool> saveMediaToLib(String path);

  Future<bool> saveNetworkImage(String path);
}
