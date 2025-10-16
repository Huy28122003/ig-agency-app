import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/views/widgets/circle_network_avatar.dart';

import '../../../../../domain/entities/group_summary.dart';
import '../../../../resources/colors.dart';

class ForwardTile extends StatelessWidget {
  final GroupSummary workspaceEntity;
  final bool isSent;
  final VoidCallback onTap;

  const ForwardTile({
    super.key,
    required this.workspaceEntity,
    required this.isSent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 8, bottom: 12, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleNetworkAvatar(
                imageUrl: workspaceEntity.avatar,
                isGroupAvt: true,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  workspaceEntity.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 24 / 16,
                    color: AppColors.textDefaultTextDefault,
                    fontFamily: FontFamily.segoeUI,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (isSent) return;
                  onTap.call();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSent
                        ? AppColors.surfaceContainerSecondarySecondaryDefault
                              .withValues(alpha: 0.5)
                        : AppColors.surfaceContainerSecondarySecondaryDefault,
                  ),

                  padding: EdgeInsets.only(
                    top: 8,
                    right: 16,
                    bottom: 12,
                    left: 16,
                  ),
                  child: Text(
                    "general.send".tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 16 / 14,
                      color: AppColors.textDefaultTextInverted,
                      fontFamily: FontFamily.segoeUI,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 56),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.outlineGrayStrong200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
