import 'dart:async';
import 'package:ig_agency_app/domain/entities/linked_device/linked_device_entity.dart';
import 'package:ig_agency_app/domain/entities/linked_device/log_recent_login_entity.dart';

abstract class LinkedDeviceRepository {
  Future<LinkedDeviceEntity> getCurrentDevice();
  Future<List<LinkedDeviceEntity>> getListDevice();
  Future<List<LogRecentLoginEntity>> getListRecentLogin();
  Future<bool> logoutDevice(List<LinkedDeviceEntity> devices);
}
