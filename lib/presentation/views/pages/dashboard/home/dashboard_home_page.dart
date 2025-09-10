import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/dashboard/home/layout/dashboard_home_tablet_layout.dart';

import 'layout/dashboard_home_mobile_layout.dart';
import 'dashboard_home_bloc.dart';

@RoutePage()
class DashboardHomePage extends BasePage<DashboardHomeBloc, DashboardHomeEvent, DashboardHomeState> {
  const DashboardHomePage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<DashboardHomeBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return DashboardHomeMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return DashboardHomeTabletLayout();
  }
}
