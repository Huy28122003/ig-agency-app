import 'dart:async';
import 'package:ig_agency_app/domain/entities/linked_device/linked_device_entity.dart';
import 'package:ig_agency_app/domain/entities/linked_device/linked_device_type.dart';
import 'package:ig_agency_app/domain/entities/linked_device/log_recent_login_entity.dart';
import 'package:ig_agency_app/domain/repositories/linked_device_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LinkedDeviceRepository)
class LinkedDeviceRepositoryImpl implements LinkedDeviceRepository {
  @override
  Future<LinkedDeviceEntity> getCurrentDevice() {
    return Future.value(
      LinkedDeviceEntity(
        name: 'iPhone 13 Pro Max',
        address: 'Hanoi, Vietnam',
        date: DateTime.now(),
        deviceType: LinkedDeviceType.mobile,
      ),
    );
  }

  @override
  Future<List<LinkedDeviceEntity>> getListDevice() {
    return Future.value([
      LinkedDeviceEntity(
        name: 'iPhone 15 Pro Max',
        address: 'Hanoi, Vietnam',
        date: DateTime.now(),
        deviceType: LinkedDeviceType.mobile,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
      LinkedDeviceEntity(
        name: 'MacBook Pro 2020',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        deviceType: LinkedDeviceType.macos,
      ),
      LinkedDeviceEntity(
        name: 'iPad Air 4',
        address: 'Hanoi, Vietnam',
        date: DateTime.now().subtract(const Duration(days: 2)),
        deviceType: LinkedDeviceType.ipad,
      ),
    ]);
  }

  @override
  Future<List<LogRecentLoginEntity>> getListRecentLogin() {
    return Future.value([
      LogRecentLoginEntity(address: 'Hanoi, Vietnam', date: DateTime.now()),
      LogRecentLoginEntity(
        address: 'New York, USA',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      LogRecentLoginEntity(
        address: 'London, UK',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      LogRecentLoginEntity(
        address: 'Tokyo, Japan',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      LogRecentLoginEntity(
        address: 'Sydney, Australia',
        date: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ]);
  }

  @override
  Future<bool> logoutDevice(List<LinkedDeviceEntity> devices) {
    return Future.value(true);
  }
}
