import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/login/layout/login_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/login/layout/login_tablet_layout.dart';

import 'login_bloc.dart';

@RoutePage()
class LoginPage extends BasePage<LoginBloc, LoginEvent, LoginState> {
  const LoginPage({super.key});

  @override
  bool get needRemoveSplash => true;

  @override
  Widget mobileBuilder(BuildContext context) {
    return LoginMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return LoginTabletLayout();
  }
}
