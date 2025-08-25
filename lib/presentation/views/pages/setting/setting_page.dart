import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/setting_tablet_layout.dart';
import 'layout/setting_mobile_layout.dart';
import 'setting_bloc.dart';

@RoutePage()
class SettingPage extends BasePage<SettingBloc, SettingEvent, SettingState> {
  const SettingPage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<SettingBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return SettingMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return SettingTabletLayout();
  }
}
