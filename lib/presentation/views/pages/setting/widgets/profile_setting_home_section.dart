import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../domain/entities/user_entity.dart';
import '../../../widgets/circle_network_avatar.dart';
import '../home/setting_home_bloc.dart';

class ProfileSettingHomeSection extends StatelessWidget {
  const ProfileSettingHomeSection({super.key, this.onEdit});

  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingHomeBloc, SettingHomeState, UserEntity?>(
      selector: (state) => state.user,
      builder: (context, user) {
        final currentUser = user;

        if (currentUser == null) {
          return const SizedBox();
        }

        return GestureDetector(
          onTap: onEdit,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: AppColors.surfaceContainerGrayStrong05,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: AppColors.outlineGrayStrong200,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              spacing: 12,
              children: [
                CircleNetworkAvatar(imageUrl: currentUser.avatar, size: 44),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser.name,
                        style: TextStyle(
                          color: AppColors.textDefaultTextDefault,
                          fontSize: 16,
                          fontFamily: FontFamily.segoeUI,
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentUser.email,
                        style: TextStyle(
                          color: AppColors.textDefaultTextSub2,
                          fontSize: 14,
                          fontFamily: FontFamily.segoeUI,
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Assets.icons.icEdit.svg(
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.iconDefaultDefault,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
