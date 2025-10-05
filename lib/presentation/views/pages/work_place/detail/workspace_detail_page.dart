import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';

import 'layout/workspace_detail_tablet_layout.dart';
import 'layout/workspace_detail_mobile_layout.dart';
import 'layout/workspace_detail_web_layout.dart';
import 'workspace_detail_bloc.dart';

@RoutePage()
class WSDetailPage
    extends BasePage<WSDetailBloc, WSDetailEvent, WSDetailState> {
  const WSDetailPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupAvatar,
    this.isSearchMode = false,
  });

  final String groupId;
  final String groupName;
  final String groupAvatar;
  final bool isSearchMode;

  @override
  WSDetailBloc get buildBloc => super.buildBloc..groupId = groupId;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<WSDetailBloc>().add(LoadDataEvent(isSearchMode));
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return WorkspaceDetailMobileLayout(
      groupName: groupName,
      groupAvatar: groupAvatar,
    );
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return WorkspaceDetailTabletLayout(
      groupName: groupName,
      groupAvatar: groupAvatar,
    );
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return WorkspaceDetailDesktopLayout();
  }
}
