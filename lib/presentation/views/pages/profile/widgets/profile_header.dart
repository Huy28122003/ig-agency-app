import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/views/widgets/circle_network_avatar.dart';

import '../../../../../domain/entities/user_entity.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/fonts.gen.dart';
import '../../../../resources/colors.dart';
import '../profile_bloc.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProfileBloc, ProfileState, UserEntity?>(
      selector: (state) {
        return state.user;
      },
      builder: (context, user) {
        final currentUser = user;

        if (currentUser == null) {
          return const SizedBox();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            _buildAvatar(currentUser.avatar),
            _buildInfo(currentUser.name, currentUser.email),
          ],
        );
      },
    );
  }

  Widget _buildAvatar(String avatar) {
    return Stack(
      children: [
        CircleNetworkAvatar(imageUrl: avatar, size: 80),
        Positioned(
          right: 4,
          bottom: 4,
          child: Container(
            width: 20,
            height: 20,
            decoration: ShapeDecoration(
              color: AppColors.iconDefaultDefaultInverted,
              shape: OvalBorder(),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 3.19,
                right: 3.19,
                top: 4.17,
                bottom: 4.94,
              ),
              child: Assets.icons.icCamera.svg(
                width: 13.61,
                height: 10.89,
                colorFilter: ColorFilter.mode(
                  AppColors.iconDefaultDefault,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(String name, String email) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: AppColors.textDefaultTextDefault,
                    fontSize: 20,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w700,
                    height: 1.30,
                  ),
                ),
              ),
              Assets.icons.icEdit.svg(
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  AppColors.iconDefaultDefault,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          Text(
            email,
            style: TextStyle(
              color: AppColors.textDefaultTextSub2,
              fontSize: 14,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }
}
