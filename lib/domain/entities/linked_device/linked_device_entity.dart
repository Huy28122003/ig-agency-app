import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:ig_agency_app/domain/entities/linked_device/linked_device_type.dart';

class LinkedDeviceEntity extends Equatable {
  const LinkedDeviceEntity({
    this.name,
    this.address,
    this.date,
    this.deviceType = LinkedDeviceType.unknown,
    this.isThisDevice = false,
  });

  final String? name;
  final String? address;
  final DateTime? date;
  final LinkedDeviceType deviceType;
  final bool isThisDevice;

  LinkedDeviceEntity copyWith({
    ValueGetter<String?>? name,
    ValueGetter<String?>? address,
    ValueGetter<DateTime?>? date,
    LinkedDeviceType? deviceType,
    bool? isThisDevice,
  }) {
    return LinkedDeviceEntity(
      name: name != null ? name() : this.name,
      address: address != null ? address() : this.address,
      date: date != null ? date() : this.date,
      deviceType: deviceType ?? this.deviceType,
      isThisDevice: isThisDevice ?? this.isThisDevice,
    );
  }

  @override
  List<Object?> get props {
    return [name, address, date, deviceType, isThisDevice];
  }
}
