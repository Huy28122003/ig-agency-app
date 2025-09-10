import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';

import '../../widgets/general_setting_home_section.dart';
import '../../widgets/log_out_button.dart';
import '../../widgets/profile_setting_home_section.dart';
import '../../../../widgets/header_home_view.dart';
import '../setting_home_bloc.dart';

class SettingHomeMobileLayout extends StatefulWidget {
  const SettingHomeMobileLayout({super.key});

  @override
  State<SettingHomeMobileLayout> createState() => _SettingHomeMobileLayoutState();
}

class _SettingHomeMobileLayoutState extends State<SettingHomeMobileLayout> {
  late final SettingHomeBloc _settingHomeBloc;

  @override
  void initState() {
    super.initState();
    _settingHomeBloc = context.read<SettingHomeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingHomeBloc, SettingHomeState>(
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
            const HeaderHomeView(title: 'Settings', padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 20,
                  children: [
                    ProfileSettingHomeSection(
                      onEdit: () {
                        context.router.push(const ProfileRoute());
                      },
                    ),
                    const GeneralSettingHomeSection(),
                    LogOutButton(
                      onLogOut: () {
                        _settingHomeBloc.add(LogoutEvent());
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
