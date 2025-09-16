import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/login_history_tablet_layout.dart';
import 'layout/login_history_mobile_layout.dart';
import 'login_history_bloc.dart';

@RoutePage()
class LoginHistoryPage
    extends BasePage<LoginHistoryBloc, LoginHistoryEvent, LoginHistoryState> {
  const LoginHistoryPage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<LoginHistoryBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return LoginHistoryMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return LoginHistoryTabletLayout();
  }
}
