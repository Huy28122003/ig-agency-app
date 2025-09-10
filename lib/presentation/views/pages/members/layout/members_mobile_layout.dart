import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/views/pages/members/widgets/member_tile_widget.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_list_view.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../resources/colors.dart';
import '../bloc/members_bloc.dart';

class MembersMobileLayout extends StatefulWidget {
  const MembersMobileLayout({super.key});

  @override
  State<MembersMobileLayout> createState() => _MembersMobileLayoutState();
}

class _MembersMobileLayoutState extends State<MembersMobileLayout> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leadingWidth: 52,
          leading: Container(
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            child: IconButton(
              padding: EdgeInsets.all(8),
              onPressed: () {
                context.router.pop();
              },
              icon: Assets.icons.icArrowLeft.svg(
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.iconDefaultDefaultSub2,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'members.title'.tr(),
                style: TextStyle(
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  height: 28 / 22,
                  color: AppColors.textDefaultTextDefault,
                ),
              ),
              BlocSelector<MembersBloc, MembersState, (int, int)>(
                selector: (state) {
                  return (state.countMember, state.countActiveMember);
                },
                builder: (context, state) {
                  final countMember = state.$1;
                  final countActiveMember = state.$2;
                  return Text(
                    //todo: chua biet api tra ve nhu nao
                    "$countMember ${'members.members'.tr()}, $countActiveMember ${'members.online'.tr()}",
                    style: TextStyle(
                      fontFamily: FontFamily.segoeUI,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 16 / 14,
                      color: AppColors.textDefaultTextSub2,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: BlocBuilder<MembersBloc, MembersState>(
          buildWhen: (pre, cur) {
            return pre.pagingStatus != cur.pagingStatus ||
                pre.members != cur.members;
          },
          builder: (context, state) {
            return AppListView<UserEntity>(
              padding: EdgeInsets.only(bottom: 10),
              separatorBuilder: (context, index) {
                return SizedBox();
              },
              fetchStatus: state.pagingStatus,
              onLoadMore: () {
                context.read<MembersBloc>().add(GetDataEvent());
              },
              enablePullDown: false,
              data: state.members,
              numCardLoading: 15,
              builder: (context, index) {
                final member = state.members[index];
                return MemberTileWidget(
                  avatar: member.avatar,
                  name: member.name,
                  isAdmin: member.isAdmin,
                  lastActiveAt: member.lastActiveAt ?? DateTime.now(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
