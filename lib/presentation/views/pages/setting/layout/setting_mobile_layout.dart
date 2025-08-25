import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ig_agency_app/presentation/views/pages/setting/setting_bloc.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';

import '../widgets/general_setting_section.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_section.dart';
import '../widgets/setting_mobile_header.dart';

class SettingMobileLayout extends StatefulWidget {
  const SettingMobileLayout({super.key});

  @override
  State<SettingMobileLayout> createState() => _SettingMobileLayoutState();
}

class _SettingMobileLayoutState extends State<SettingMobileLayout> {
  late final SettingBloc _settingBloc;

  @override
  void initState() {
    super.initState();
    _settingBloc = context.read<SettingBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) {
        if (state.isLogoutSuccess) {
          context.router.replaceAll([const LoginRoute()]);
        }
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SettingMobileHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 20,
                  children: [
                    ProfileSection(
                      onEdit: () {
                        // TODO hoannk: Route
                      },
                    ),
                    GeneralSettingSection(settingBloc: _settingBloc),
                    LogoutButton(
                      onLogout: () {
                        _settingBloc.add(LogoutEvent());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
