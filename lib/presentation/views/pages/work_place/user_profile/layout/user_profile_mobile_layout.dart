import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/shared/utils/widget_util.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/fonts.gen.dart';
import '../../../../../resources/colors.dart';
import '../../../../../routers/app_router.dart';
import '../../../../widgets/circle_network_avatar.dart';
import '../user_profile_bloc.dart';

class UserProfileMobileLayout extends StatefulWidget {
  const UserProfileMobileLayout({super.key});

  @override
  State<UserProfileMobileLayout> createState() =>
      _UserProfileMobileLayoutState();
}

class _UserProfileMobileLayoutState extends State<UserProfileMobileLayout> {
  late final UserProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = context.read<UserProfileBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        // systemOverlayStyle: SystemUiOverlayStyle.light, // Light status bar
        backgroundColor: AppColors.surfaceContainerPrimaryPrimaryDefault,
        elevation: 0,
        toolbarHeight: 60,
        title: Text(
          'Profile Info',
          style: TextStyle(
            color: AppColors.textDefaultTextInverted,
            fontSize: 22,
            fontFamily: FontFamily.segoeUI,
            fontWeight: FontWeight.w700,
            height: 1.27,
          ),
        ),
        centerTitle: true,
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
                AppColors.iconDefaultDefaultInverted,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.outlineGrayStrong200, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            spacing: 20,
            children: [
              _buildAvatar(
                _profileBloc.state.user?.avatar ?? '',
                _profileBloc.state.user?.name ?? '',
              ),
              _buildListAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String avatar, String fullName) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 52),
          padding: const EdgeInsets.only(
            top: 25,
            bottom: 12,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE5E7EB), width: 1),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                'Active now',
                style: TextStyle(
                  color: Color(0xFF6A7282),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                fullName,
                style: TextStyle(
                  color: AppColors.textDefaultTextDefault,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              Text(
                '''There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.''',
                style: TextStyle(
                  color: Color(0xFF6A7282),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Center(
          child: Stack(
            children: [
              CircleNetworkAvatar(imageUrl: avatar, size: 80),
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Color(0xFF00C950),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildBlock(
            title: 'Block',
            icon: Assets.icons.icUserRemove.svg(width: 24, height: 24),
            onTap: () {
              //TODO
            },
          ),
        ),
        //TODO: ẩn hiện theo role admin
        Expanded(
          child: _buildBlock(
            title: 'Add to group',
            icon: Assets.icons.icAddMembers.svg(width: 24, height: 24),
            onTap: () {
              //TODO
            },
          ),
        ),
        Expanded(
          child: _buildBlock(
            title: 'Report',
            icon: Assets.icons.icFlag.svg(width: 24, height: 24),
            onTap: () {
              //TODO
            },
          ),
        ),
      ].divide(const SizedBox(width: 8)),
    );
  }

  Widget _buildBlock({
    required String title,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xFFFEF1D6),
        border: Border.all(color: Color(0xFFFCB732), width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          icon,
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textDefaultTextDefault,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
