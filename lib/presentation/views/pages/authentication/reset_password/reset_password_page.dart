import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/reset_password/bloc/reset_password_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/reset_password/layout/reset_password_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/reset_password/layout/reset_password_tablet_layout.dart';

@RoutePage()
class ResetPasswordPage
    extends
        BasePage<ResetPasswordBloc, ResetPasswordEvent, ResetPasswordState> {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<ResetPasswordBloc>().add(LoadDataEvent(email));
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return ResetPasswordMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return ResetPasswordTabletLayout();
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return ResetPasswordTabletLayout();
  }
}
