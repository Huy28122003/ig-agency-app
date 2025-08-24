import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/registration/registration_bloc.dart';

import '../../../../../routers/app_router.dart';
import '../../../../../views/widgets/authentication_mobile_layout.dart';
import '../widgets/registration_footer.dart';
import '../widgets/registration_mobile_form.dart';
import '../widgets/registration_mobile_header.dart';

class RegistrationMobileLayout extends StatefulWidget {
  const RegistrationMobileLayout({super.key});

  @override
  State<RegistrationMobileLayout> createState() =>
      _RegistrationMobileLayoutState();
}

class _RegistrationMobileLayoutState extends State<RegistrationMobileLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listenWhen: (pre, cur) => pre.isSuccess != cur.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          context.router.replaceAll([NavRoute()]);
        }
      },
      child: AuthenticationMobileLayout(
        header: RegistrationMobileHeader(),
        form: RegistrationMobileForm(),
        footer: RegistrationFooter(),
      ),
    );
  }
}
