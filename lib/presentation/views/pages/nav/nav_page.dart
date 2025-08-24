import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/nav/layout/nav_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/nav/layout/nav_tablet_layout.dart';

import 'nav_bloc.dart';

@RoutePage()
class NavPage extends BasePage<NavBloc, NavEvent, NavState> {
  const NavPage({super.key});

  @override
  Widget mobileBuilder(BuildContext context) {
    return NavMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return NavTabletLayout();
  }
}
