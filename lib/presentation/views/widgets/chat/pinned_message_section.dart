import 'package:flutter/material.dart';
import 'package:ig_agency_app/domain/entities/message/message_entity.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../resources/colors.dart';

class PinnedMessageSection extends StatelessWidget {
  const PinnedMessageSection({
    super.key,
    required this.latestPinnedMessage,
    required this.totalMessages,
  });

  final MessageEntity latestPinnedMessage;
  final int totalMessages;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.surfaceContainerGrayStrong1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        spacing: 6,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 12,
              children: [
                Assets.icons.icPinned.svg(width: 20, height: 20),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      SizedBox(
                        width: 247,
                        child: Text(
                          latestPinnedMessage.sender.name,
                          style: TextStyle(
                            color: AppColors.textDefaultTextDefault,
                            fontSize: 14,
                            fontFamily: FontFamily.segoeUI,
                            fontWeight: FontWeight.w700,
                            height: 1.43,
                          ),
                        ),
                      ),
                      Text(
                        'https://docs.google.com/spreadsheets/d/16WB1MasxuLNu3YMlEo_QFDu65HKVWSfWYyZev2UCicQ/edit?gid=1320495092#gid=1320495092A',
                        style: TextStyle(
                          color: AppColors.textDefaultTextDefault,
                          fontSize: 12,
                          fontFamily: FontFamily.segoeUI,
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 4,
            children: [
              Text(
                '${totalMessages - 1} more',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textDefaultTextSub2,
                  fontSize: 12,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w700,
                  height: 1.33,
                ),
              ),
              Assets.icons.icArrowDownFillSize12.svg(width: 12, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}
