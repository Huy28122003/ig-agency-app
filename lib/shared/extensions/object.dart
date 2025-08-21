import 'package:responsive_builder/responsive_builder.dart';

extension ObjectExtension on Object {
  T? as<T>() {
    if (this is T) {
      return this as T;
    }

    return null;
  }
}

extension SizingInformationExtension on SizingInformation {
  bool get isMobile => deviceScreenType == DeviceScreenType.mobile;

  bool get isTablet => deviceScreenType == DeviceScreenType.tablet;

  bool get isDesktop => deviceScreenType == DeviceScreenType.desktop;
}
