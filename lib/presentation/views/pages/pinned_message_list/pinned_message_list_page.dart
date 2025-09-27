import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/views/pages/pinned_message_list/bloc/pinned_message_list_bloc.dart';
import 'package:ig_agency_app/presentation/views/pages/pinned_message_list/layout/pinned_message_list_mobile_layout.dart';
import 'package:ig_agency_app/presentation/views/pages/pinned_message_list/layout/pinned_message_list_tablet_layout.dart';

@RoutePage()
class PinnedMessageListPage
    extends
        BasePage<
          PinnedMessageListBloc,
          PinnedMessageListEvent,
          PinnedMessageListState
        > {
  const PinnedMessageListPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupAvatar,
  });

  final int groupId;
  final String groupAvatar;
  final String groupName;

  @override
  PinnedMessageListBloc get buildBloc => super.buildBloc
    ..groupId = groupId
    ..groupName = groupName
    ..groupAvatar = groupAvatar;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<PinnedMessageListBloc>().add(LoadDataEvent());
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return PinnedMessageListMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return PinnedMessageListTabletLayout();
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    return PinnedMessageListTabletLayout();
  }
}
