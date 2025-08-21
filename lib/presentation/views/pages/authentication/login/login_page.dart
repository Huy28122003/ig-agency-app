import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/login/layout/login_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/login/layout/login_tablet_layout.dart';

import 'login_bloc.dart';

@RoutePage()
class LoginPage extends BasePage<LoginBloc, LoginEvent, LoginState> {
  const LoginPage({super.key});

  @override
  void onInitState(BuildContext context) {
    context.read<LoginBloc>().add(LoadDataEvent());
    super.onInitState(context);
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return LoginMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return LoginTabletLayout();
  }
}
