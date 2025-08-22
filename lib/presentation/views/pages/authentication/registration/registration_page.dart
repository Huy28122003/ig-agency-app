import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/registration_mobile_layout.dart';
import 'layout/registration_tablet_layout.dart';
import 'registration_bloc.dart';

@RoutePage()
class RegistrationPage
    extends BasePage<RegistrationBloc, RegistrationEvent, RegistrationState> {
  const RegistrationPage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<RegistrationBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return RegistrationMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return RegistrationTabletLayout();
  }
}
