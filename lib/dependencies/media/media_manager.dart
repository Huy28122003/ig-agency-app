import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

abstract class MediaManager {
  Future<XFile?> pickMedia();

  Future<bool> saveLocalImage(GlobalKey key);

  Future<bool> saveNetworkImage(String path);
}
