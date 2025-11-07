import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/base/base_page.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/pages/group_info/bloc/group_info_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_bar_widget.dart';

import '../../../../gen/assets.gen.dart';
import '../../../models/group_info_arguments.dart';
import 'layout/group_info_desktop_layout.dart';
import 'layout/group_info_mobile_layout.dart';
import 'layout/group_info_tablet_layout.dart';

@RoutePage()
class GroupInfoPage
    extends BasePage<GroupInfoBloc, GroupInfoEvent, GroupInfoState> {
  const GroupInfoPage({super.key, required this.groupId});

  final String groupId;

  @override
  GroupInfoBloc get buildBloc => super.buildBloc..groupId = groupId;

  @override
  void onInitState(BuildContext context) {
    super.onInitState(context);
    context.read<GroupInfoBloc>().add(LoadDataEvent(groupId: groupId));
  }

  @override
  PreferredSizeWidget? appbarMobileBuilder(BuildContext context) {
    return AppBarWidget(
      title: 'group_info.title'.tr(),
      actions: [
        IconButton(
          padding: EdgeInsets.all(8),
          onPressed: () {
            final state = context.read<GroupInfoBloc>().state;
            context.router.pop(
              GroupInfoArguments(
                groupName: state.name,
                groupAvatar: state.avatar,
              ),
            );
          },
          icon: Assets.icons.icArrowLeft.svg(
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              AppColors.iconDefaultDefaultInverted,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.outlineGrayStrong200, height: 1),
      ),
    );
  }

  @override
  Widget mobileBuilder(BuildContext context) {
    return GroupInfoMobileLayout();
  }

  @override
  Widget? tabletBuilder(BuildContext context) {
    return GroupInfoTabletLayout();
  }

  @override
  Widget? desktopBuilder(BuildContext context) {
    // TODO: implement
    return GroupInfoDesktopLayout();
  }
}
