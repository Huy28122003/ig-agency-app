import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/setting_home_mobile_layout.dart';
import 'layout/setting_home_tablet_layout.dart';
import 'setting_home_bloc.dart';

@RoutePage()
class SettingHomePage
    extends BasePage<SettingHomeBloc, SettingHomeEvent, SettingHomeState> {
  const SettingHomePage({super.key});

  @override
  void onInitState(BuildContext context) {
    context.read<SettingHomeBloc>().add(LoadDataEvent());
    super.onInitState(context);
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return SettingHomeMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return SettingHomeTabletLayout();
  }
}
