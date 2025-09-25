import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/shared/extensions/date_time_extension.dart';

import '../../../../../../gen/assets.gen.dart';

class WorkspaceTileTabletWidget extends StatefulWidget {
  const WorkspaceTileTabletWidget({
    super.key,
    required this.workspaceAvatar,
    required this.workspaceName,
    required this.lastMessage,
    this.lastMessageTime,
    required this.isSeen,
    required this.isMute,
    required this.isPin,
    required this.countNewMessage,
    required this.onTap,
    required this.isSelected,
  });

  final String workspaceAvatar;
  final String workspaceName;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final bool isSeen;
  final bool isMute;
  final bool isPin;
  final int countNewMessage;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  State<WorkspaceTileTabletWidget> createState() =>
      _WorkspaceTileTabletWidgetState();
}

class _WorkspaceTileTabletWidgetState extends State<WorkspaceTileTabletWidget> {
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.only(left: 20, top: 8, right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.isSelected
              ? AppColors.surfaceContainerPrimaryPrimaryLight
              : null,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                fit: BoxFit.cover,
                widget.workspaceAvatar,
                width: 48,
                height: 48,
                errorBuilder: (context, error, stackTrace) {
                  return ClipOval(
                    child: Assets.images.imgDefaultGroupAvatar.image(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.workspaceName,
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

                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    (widget.countNewMessage > 1 &&
                                            !widget.isSeen)
                                        ? "${widget.countNewMessage} new messages"
                                        : widget.lastMessage,
                                    style: TextStyle(
                                      fontFamily: FontFamily.segoeUI,
                                      fontSize: 14,
                                      height: 20 / 14,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: widget.isSeen
                                          ? FontWeight.w400
                                          : FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),

                                if (widget.lastMessageTime != null) ...[
                                  SizedBox(width: 4),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.textDefaultTextSub2,
                                    ),
                                    width: 4,
                                    height: 4,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    widget.lastMessageTime!
                                        .convertDateTimeToString(),
                                    style: TextStyle(
                                      fontFamily: FontFamily.segoeUI,
                                      fontSize: 14,
                                      height: 20 / 14,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12),
                      if (widget.isPin) Assets.icons.icPin.svg(),
                      if (!widget.isMute)
                        Assets.icons.icBlockNotification.svg(),
                      if (!widget.isSeen)
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.iconPrimaryDefault,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: AppColors.outlineGrayStrong200,
                  ),
                  SizedBox(height: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
