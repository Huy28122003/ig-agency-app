import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../routers/app_router.dart';
import '../login_bloc.dart';

class LoginTabletLayout extends StatefulWidget {
  const LoginTabletLayout({super.key});

  @override
  State<LoginTabletLayout> createState() => _LoginTabletLayoutState();
}

class _LoginTabletLayoutState extends State<LoginTabletLayout> {
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
