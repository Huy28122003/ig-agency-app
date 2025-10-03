import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/nav/layout/nav_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/nav/layout/nav_tablet_layout.dart';

import 'layout/nav_web_layout.dart';
import 'nav_bloc.dart';

@RoutePage()
class NavPage extends BasePage<NavBloc, NavEvent, NavState> {
  const NavPage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<NavBloc>().add(LoadDataEvent());
  }

  @override
  bool get needRemoveSplash => true;

  @override
  Widget mobileBuilder(BuildContext context) {
    return NavMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return NavTabletLayout();
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return NavDesktopLayout();
  }
}
