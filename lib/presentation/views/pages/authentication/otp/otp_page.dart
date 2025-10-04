import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/otp/bloc/otp_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/otp/layout/otp_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/otp/layout/otp_tablet_layout.dart';

@RoutePage()
class OtpPage extends BasePage<OtpBloc, OtpEvent, OtpState> {
  final String email;
  final String otpVerified;

  const OtpPage({super.key, required this.email, required this.otpVerified});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<OtpBloc>().add(LoadDataEvent(email, otpVerified));
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return OtpMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return OtpTabletLayout();
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return OtpTabletLayout();
  }
}
