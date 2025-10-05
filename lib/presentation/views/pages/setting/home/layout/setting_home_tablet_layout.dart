import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';

import '../../../../widgets/header_home_view.dart';
import '../../widgets/general_setting_home_section.dart';
import '../../widgets/log_out_button.dart';
import '../../widgets/profile_setting_home_section.dart';
import '../setting_home_bloc.dart';

class SettingHomeTabletLayout extends StatelessWidget {
  const SettingHomeTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingHomeBloc, SettingHomeState>(
      listener: (context, state) {
        if (state.isLogoutSuccess) {
          context.router.replaceAll([const LoginRoute()]);
        }
      },
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          backgroundColor: AppColors.surfaceContainerGrayStrong0,
          body: Column(
            children: [
              HeaderHomeView(
                title: 'setting.title'.tr(),
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 30,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    spacing: 20,
                    children: [
                      ProfileSettingHomeSection(
                        onEdit: () {
                          final email = context
                              .read<SettingHomeBloc>()
                              .state
                              .email;
                          context.router.push(ProfileRoute(email: email));
                        },
                      ),
                      const GeneralSettingHomeSection(),
                      LogOutButton(
                        onLogOut: () {
                          context.read<SettingHomeBloc>().add(LogoutEvent());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
