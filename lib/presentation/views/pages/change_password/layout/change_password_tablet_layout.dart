import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import '../change_password_bloc.dart';

class ChangePasswordTabletLayout extends StatefulWidget {
  const ChangePasswordTabletLayout({super.key});

  @override
  State<ChangePasswordTabletLayout> createState() =>
      _ChangePasswordTabletLayoutState();
}

class _ChangePasswordTabletLayoutState
    extends State<ChangePasswordTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state.isSaveSuccess) {
          context.router.pop();
        }
      },
      child: SizedBox(),
    );
  }
}
