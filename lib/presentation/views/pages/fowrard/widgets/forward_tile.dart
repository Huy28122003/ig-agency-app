import 'package:flutter/material.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../resources/colors.dart';

class ForwardTile extends StatelessWidget {
  final WorkspaceEntity workspaceEntity;

  const ForwardTile({super.key, required this.workspaceEntity});

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
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  workspaceEntity.workspaceAvatar,
                  fit: BoxFit.cover,
                  width: 48,
                  height: 48,
                  errorBuilder: (context, error, stackTrace) {
                    return ClipOval(
                      child: Assets.icons.icDefaultAvatar.svg(
                        fit: BoxFit.cover,
                        width: 48,
                        height: 48,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  workspaceEntity.workspaceName,
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.surfaceContainerSecondarySecondaryDefault,
                ),

                padding: EdgeInsets.only(
                  top: 8,
                  right: 16,
                  bottom: 12,
                  left: 16,
                ),
                child: Text(
                  "Send",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 16 / 14,
                    color: AppColors.textDefaultTextInverted,
                    fontFamily: FontFamily.segoeUI,
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
