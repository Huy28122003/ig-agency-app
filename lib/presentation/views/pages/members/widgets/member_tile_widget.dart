import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/presentation/views/widgets/circle_network_avatar.dart';
import 'package:ig_agency_app/shared/extensions/date_time_extension.dart';


class MemberTileWidget extends StatelessWidget {
  const MemberTileWidget({
    super.key,
    required this.avatar,
    required this.name,
    required this.isAdmin,
    required this.lastActiveAt,
  });

  final String avatar;
  final String name;
  final bool isAdmin;
  final DateTime lastActiveAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleNetworkAvatar(imageUrl: avatar),
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
                              Text(
                                name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  height: 26 / 18,
                                  color: AppColors.textDefaultTextDefault,
                                  fontFamily: FontFamily.segoeUI,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${'members.active'.tr()} ${lastActiveAt.toRelativeString} ${'members.ago'.tr()}',
                                style: TextStyle(
                                  fontFamily: FontFamily.segoeUI,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  height: 20 / 14,
                                  color: AppColors.textDefaultTextSub2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isAdmin
                              ? "members.role_admin".tr()
                              : "members.role_member".tr(),
                          style: TextStyle(
                            fontFamily: FontFamily.segoeUI,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 20 / 14,
                            color: AppColors.textSecondaryTextSub,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: AppColors.outlineGrayStrong200,
                    ),
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
