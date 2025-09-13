import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/user_profile_tablet_layout.dart';
import 'layout/user_profile_mobile_layout.dart';
import 'user_profile_bloc.dart';

@RoutePage()
class UserProfilePage
    extends BasePage<UserProfileBloc, UserProfileEvent, UserProfileState> {
  const UserProfilePage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<UserProfileBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return UserProfileMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return UserProfileTabletLayout();
  }
}
