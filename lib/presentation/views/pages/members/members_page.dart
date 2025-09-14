import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/members/bloc/members_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/members/layout/members_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/members/layout/members_tablet_layout.dart';

import '../../../base/base_page.dart';

@RoutePage()
class MembersPage extends BasePage<MembersBloc, MembersEvent, MembersState> {
  const MembersPage({super.key, required this.workspaceId});

  final int workspaceId;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<MembersBloc>().add(LoadDataEvent(workspaceId: workspaceId));
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return MembersMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return MembersTabletLayout();
  }
}
