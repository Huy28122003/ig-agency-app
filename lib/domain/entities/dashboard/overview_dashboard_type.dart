import 'package:flutter_svg/svg.dart';
import 'package:ig_agency_app/gen/assets.gen.dart';

enum OverviewDashboardType { violation, device, visit, message }

extension OverviewDashboardTypeExtension on OverviewDashboardType {
  String getTitle() {
    switch (this) {
      case OverviewDashboardType.violation:
        return 'All Violations';
      case OverviewDashboardType.device:
        return 'All Devices';
      case OverviewDashboardType.visit:
        return 'Total Visits';
      case OverviewDashboardType.message:
        return 'Total Messages';
    }
  }

  SvgPicture getIconWidget() {
    switch (this) {
      case OverviewDashboardType.violation:
        return Assets.icons.icViolation.svg();
      case OverviewDashboardType.device:
        return Assets.icons.icDevice.svg();
      case OverviewDashboardType.visit:
        return Assets.icons.icView.svg();
      case OverviewDashboardType.message:
        return Assets.icons.icMessage.svg();
    }
  }
}
