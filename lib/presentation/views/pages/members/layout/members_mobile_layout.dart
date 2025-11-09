import 'package:auto_route/auto_route.dart';
import 'package:card_loading/card_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/views/pages/members/widgets/member_tile_widget.dart';
import 'package:ig_agency_app/presentation/views/widgets/app_list_view.dart';
import '../../../../../domain/entities/member_entity.dart';
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
    return Scaffold(
      backgroundColor: AppColors.surfaceBackgroundBackground,
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
          return AppListView<MemberEntity>(
            padding: EdgeInsets.only(bottom: 10),
            separatorBuilder: (context, index) {
              return SizedBox();
            },
            fetchStatus: state.pagingStatus,
            onLoadMore: () {
              context.read<MembersBloc>().add(GetDataEvent());
            },
            onRefresh: () {
              context.read<MembersBloc>().add(RefreshDataEvent());
            },
            data: state.members,
            numCardLoading: 10,
            cardLoading: _buildLoading(),
            builder: (context, index) {
              final member = state.members[index];
              return MemberTileWidget(
                onTap: (){},
                avatar: member.user.avatar,
                name: member.user.name,
                isAdmin: member.user.isAdmin,
                lastActiveAt: member.user.lastActiveAt ?? DateTime.now(),
                isOnline: member.user.isOnline,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardLoading(
                height: 48,
                borderRadius: BorderRadius.all(Radius.circular(1000)),
                width: 48,
                margin: EdgeInsets.only(bottom: 10),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CardLoading(
                                height: 25,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                              const SizedBox(height: 6),
                              CardLoading(
                                height: 20,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                width: 150,
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        CardLoading(
                          height: 20,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          width: 80,
                          margin: EdgeInsets.only(bottom: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
