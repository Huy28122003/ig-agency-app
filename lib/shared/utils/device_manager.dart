import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:ig_agency_app/dependencies/local_storage/local_storage_manager.dart';
import 'package:ig_agency_app/di/di.dart';
import 'package:ig_agency_app/shared/utils/logger.dart';
import 'package:uuid/uuid.dart';

class DeviceManager {
  static final _storage = getIt.get<LocalStorageManager>();

  static Future<String> getOrCreateDeviceId() async {
    String? existing = await _storage.getValue(LocalStorageKeys.deviceId);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    String newId = const Uuid().v4();
    await _storage.setValue(LocalStorageKeys.deviceId, newId);
    return newId;
  }

  static Future<void> deleteDeviceId() async {
    try {
      await _storage.deleteKey(LocalStorageKeys.deviceId);
    } catch (e) {
      logger.e("Error deleting deviceId: $e");
    }
  }

  static String getDeviceType() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknow';
  }

  static Future<String?> getOsVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (kIsWeb) {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        return "${webBrowserInfo.platform} ${webBrowserInfo.appVersion}";
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.version.release;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.systemVersion;
      } else {
        return null;
      }
    } catch (e) {
      logger.e("Error getting OS version: $e");
      return null;
    }
  }

  static Future<String?> getDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (kIsWeb) {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        return webBrowserInfo.browserName.name;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.name;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.modelName;
      } else {
        return null;
      }
    } catch (e) {
      logger.e("Error getting OS version: $e");
      return null;
    }
  }
}
