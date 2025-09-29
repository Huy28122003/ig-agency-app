import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ig_agency_app/dependencies/local_storage/local_storage_manager.dart';
import 'package:ig_agency_app/di/di.dart';
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
      print("Error deleting deviceId: $e");
    }
  }

  static String getDeviceType() {
    return Platform.isAndroid ? 'android' : 'ios';
  }

  static Future<String?> getOsVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.version.release;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.systemVersion;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting OS version: $e");
      return null;
    }
  }
}
