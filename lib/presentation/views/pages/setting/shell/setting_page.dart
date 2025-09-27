import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/setting_mobile_layout.dart';
import 'layout/setting_tablet_layout.dart';
import 'setting_bloc.dart';

@RoutePage()
class SettingPage extends BasePage<SettingBloc, SettingEvent, SettingState> {
  const SettingPage({super.key});

  @override
  Widget mobileBuilder(BuildContext context) {
    return SettingMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return SettingTabletLayout();
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return SettingTabletLayout();
  }
}
