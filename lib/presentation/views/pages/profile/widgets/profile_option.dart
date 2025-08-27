import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../resources/colors.dart';
import '../profile_bloc.dart';
import 'profile_option_item.dart';

class ProfileOption extends StatelessWidget {
  const ProfileOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerGrayStrong05,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.outlineGrayStrong200),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          BlocSelector<ProfileBloc, ProfileState, String?>(
            selector: (state) {
              return state.user?.bio;
            },
            builder: (context, bio) {
              return ProfileOptionItem(
                title: 'Bio',
                iconPath: Assets.icons.icBio.path,
                onTap: () {
                  // TODO hoannk: Route to bio page
                },
                subtitle: bio,
                isFirst: true,
              );
            },
          ),
          const Divider(
            height: 1,
            indent: 54,
            endIndent: 16,
            color: AppColors.outlineGrayStrong200,
          ),
          ProfileOptionItem(
            title: 'Reset Password',
            iconPath: Assets.icons.icPassword.path,
            onTap: () {
              // TODO hoannk: Route to reset password page
            },
            isLast: true,
          ),
        ],
      ),
    );
  }
}
