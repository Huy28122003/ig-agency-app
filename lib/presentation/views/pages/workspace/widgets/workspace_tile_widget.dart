import 'package:flutter/material.dart';
import 'package:ig_agency_app/gen/fonts.gen.dart';
import 'package:ig_agency_app/presentation/resources/colors.dart';
import 'package:ig_agency_app/shared/extensions/date_time_extension.dart';

import '../../../../../gen/assets.gen.dart';

class WorkspaceTileWidget extends StatefulWidget {
  const WorkspaceTileWidget({
    super.key,
    required this.workspaceAvatar,
    required this.workspaceName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isSeen,
  });

  final String workspaceAvatar;
  final String workspaceName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isSeen;

  @override
  State<WorkspaceTileWidget> createState() => _WorkspaceTileWidgetState();
}

class _WorkspaceTileWidgetState extends State<WorkspaceTileWidget> {
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 12, right: 12),
      child: Row(
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
                  child: Assets.images.defaultAvatar.image(
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
                Text(
                  widget.workspaceName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    height: 26 / 18,
                    color: AppColors.textDefaultTextDefault,
                    fontFamily: FontFamily.segoeUI,
                  ),
                ),

                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.lastMessage,
                        style: TextStyle(
                          fontFamily: FontFamily.segoeUI,
                          fontSize: 14,
                          height: 20 / 14,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: widget.isSeen
                              ? FontWeight.w400
                              : FontWeight.w600,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 4),
                    Container(
                      color: AppColors.textDefaultTextSub2,
                      width: 4,
                      height: 4,
                    ),
                    SizedBox(width: 4),
                    Text(
                      _convertDateTimeToString(),
                      style: TextStyle(
                        fontFamily: FontFamily.segoeUI,
                        fontSize: 14,
                        height: 20 / 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          if (!widget.isSeen)
            Container(color: AppColors.iconPrimaryDefault, width: 6, height: 6),
        ],
      ),
    );
  }

  String _convertDateTimeToString() {
    final isToday =
        now.year == widget.lastMessageTime.year &&
        now.month == widget.lastMessageTime.month &&
        now.day == widget.lastMessageTime.day;
    if (isToday) {
      return widget.lastMessageTime.toHourMinuteAmPm;
    } else {
      return widget.lastMessageTime.toRelativeString;
    }
  }
}
