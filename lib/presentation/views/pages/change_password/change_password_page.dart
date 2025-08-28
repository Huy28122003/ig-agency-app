import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/change_password_tablet_layout.dart';
import 'layout/change_password_mobile_layout.dart';
import 'change_password_bloc.dart';

@RoutePage()
class ChangePasswordPage
    extends
        BasePage<ChangePasswordBloc, ChangePasswordEvent, ChangePasswordState> {
  const ChangePasswordPage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<ChangePasswordBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return ChangePasswordMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return ChangePasswordTabletLayout();
  }
}
