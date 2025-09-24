import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/group_info/bloc/group_info_bloc.dart';

import 'layout/group_info_mobile_layout.dart';
import 'layout/group_info_tablet_layout.dart';

@RoutePage()
class GroupInfoPage
    extends BasePage<GroupInfoBloc, GroupInfoEvent, GroupInfoState> {
  const GroupInfoPage({super.key, required this.groupId});

  final int groupId;

  @override
  GroupInfoBloc get buildBloc => super.buildBloc..groupId = groupId;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<GroupInfoBloc>().add(LoadDataEvent(groupId: groupId));
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return GroupInfoMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return GroupInfoTabletLayout();
  }
}
