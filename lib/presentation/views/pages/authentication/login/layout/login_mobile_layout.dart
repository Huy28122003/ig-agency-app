import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/authentication/login/login_bloc.dart';

import '../../../../../routers/app_router.dart';

class LoginMobileLayout extends StatefulWidget {
  const LoginMobileLayout({super.key});

  @override
  State<LoginMobileLayout> createState() => _LoginMobileLayoutState();
}

class _LoginMobileLayoutState extends State<LoginMobileLayout> {

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (pre, cur) => pre.isSuccess != cur.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          context.router.replaceAll([NavRoute()]);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              context.read<LoginBloc>().add(SubmitLoginEvent());
            },
            child: const Text('Login'),
          ),
        ),
      ),
    );
  }
}
