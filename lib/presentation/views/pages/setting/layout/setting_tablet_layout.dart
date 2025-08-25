import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/setting/setting_bloc.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:auto_route/auto_route.dart';

class SettingTabletLayout extends StatefulWidget {
  const SettingTabletLayout({super.key});

  @override
  State<SettingTabletLayout> createState() => _SettingTabletLayoutState();
}

class _SettingTabletLayoutState extends State<SettingTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state.isLogoutSuccess) {
            context.router.replaceAll([const LoginRoute()]);
          }
        },
        child: SizedBox.shrink(),
      ),
    );
  }
}
