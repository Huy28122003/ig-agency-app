import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'bloc/forgot_password_bloc.dart';
import 'layout/forgot_password_mobile_layout.dart';

@RoutePage()
class ForgotPasswordPage
    extends
        BasePage<ForgotPasswordBloc, ForgotPasswordEvent, ForgotPasswordState> {
  const ForgotPasswordPage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<ForgotPasswordBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return ForgotPasswordMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return null;
  }
}
