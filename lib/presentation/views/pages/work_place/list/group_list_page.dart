import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/workspace_list_desktop_layout.dart';
import 'layout/workspace_list_tablet_layout.dart';
import 'layout/workspace_list_mobile_layout.dart';
import 'group_list_bloc.dart';

@RoutePage()
class GroupListPage
    extends
        BasePage<GroupListBloc, GroupListEvent, GroupListState> {
  const GroupListPage({super.key});

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<GroupListBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return WorkspaceListMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return WorkspaceListTabletLayout();
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return WorkspaceListDesktopLayout();
  }
}
