import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/profile_desktop_layout.dart';
import 'layout/profile_tablet_layout.dart';
import 'layout/profile_mobile_layout.dart';
import 'profile_bloc.dart';

@RoutePage()
class ProfilePage extends BasePage<ProfileBloc, ProfileEvent, ProfileState> {
  const ProfilePage(this.email, {super.key});

  final String email;

  @override
  ProfileBloc get buildBloc => super.buildBloc..email =email;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<ProfileBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return ProfileMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return ProfileTabletLayout();
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return ProfileDesktopLayout();
  }
}
