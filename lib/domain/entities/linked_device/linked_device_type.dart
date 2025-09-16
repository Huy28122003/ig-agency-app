import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/assets.gen.dart';

enum LinkedDeviceType { mobile, ipad, macos, unknown }

extension FLinkedDeviceTypeExtension on LinkedDeviceType {
  Widget get getIcon {
    switch (this) {
      case LinkedDeviceType.mobile:
        return Assets.icons.icIphone.svg(width: 24, height: 24);
      case LinkedDeviceType.ipad:
        return Assets.icons.icIpad.svg(width: 24, height: 24);
      case LinkedDeviceType.macos:
        return Assets.icons.icMacOS.svg(width: 24, height: 24);
      case LinkedDeviceType.unknown:
        return Assets.icons.icUnknownDevice.svg(width: 24, height: 24);
    }
  }
}
