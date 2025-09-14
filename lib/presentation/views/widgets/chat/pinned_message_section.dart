import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../gen/fonts.gen.dart';
import '../../ui_models/pinned_message_summary_ui_model.dart';
import '../../../resources/colors.dart';

class PinnedMessageSection extends StatelessWidget {
  const PinnedMessageSection({
    super.key,
    required this.pinnedMessageSummary,
    required this.onTap,
  });

  final PinnedMessageSummaryUiModel pinnedMessageSummary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerGrayStrong1,
          // borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Assets.icons.icPinned.svg(width: 20, height: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pinnedMessageSummary.latestSenderName ?? '',
                          style: TextStyle(
                            color: AppColors.textDefaultTextDefault,
                            fontSize: 14,
                            fontFamily: FontFamily.segoeUI,
                            fontWeight: FontWeight.w700,
                            height: 1.43,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          pinnedMessageSummary.latestPinnedMessageContent ?? '',
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
            if (pinnedMessageSummary.hasMorePinnedMessages) ...[
              const SizedBox(width: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${pinnedMessageSummary.totalPinnedMessages - 1} more',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textDefaultTextSub2,
                      fontSize: 12,
                      fontFamily: FontFamily.segoeUI,
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                    ),
                  ),
                  SizedBox(width: 4),
                  Assets.icons.icArrowDownFillSize12.svg(width: 12, height: 12),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
