import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../routers/app_router.dart';
import '../../../../../views/widgets/authentication_tablet_layout.dart';
import '../registration_bloc.dart';
import '../widgets/registration_footer.dart';
import '../widgets/registration_tablet_form.dart';

class RegistrationTabletLayout extends StatefulWidget {
  const RegistrationTabletLayout({super.key});

  @override
  State<RegistrationTabletLayout> createState() =>
      _RegistrationTabletLayoutState();
}

class _RegistrationTabletLayoutState extends State<RegistrationTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listenWhen: (pre, cur) => pre.isSuccess != cur.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          context.router.replaceAll([NavRoute()]);
        }
      },
      child: AuthenticationTabletLayout(
        title: 'Registration',
        form: RegistrationTabletForm(),
        footer: RegistrationFooter(),
      ),
    );
  }
}
