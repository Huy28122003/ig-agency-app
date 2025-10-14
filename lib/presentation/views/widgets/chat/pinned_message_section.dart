import 'package:flutter/material.dart';

import '../../../../domain/entities/message/message.dart';
import '../../../../domain/entities/pinned_message_summary.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../resources/colors.dart';

class PinnedMessageSection extends StatelessWidget {
  const PinnedMessageSection({
    super.key,
    required this.pinnedMessageSummary,
    required this.onTap,
  });

  final PinnedMessageSummary pinnedMessageSummary;
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
                          pinnedMessageSummary.recentPinnedMessage?.user.name ?? '',
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
                          _extractContent(pinnedMessageSummary.recentPinnedMessage),
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
            if (pinnedMessageSummary.totalPinnedMessages > 1 &&
                pinnedMessageSummary.recentPinnedMessage != null) ...[
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

  String _extractContent(MessageEntity? message) {
    if (message == null) return '';

    final content = message.content;
    switch (content) {
      case TextMessageContent _:
        return content.text;
      case ImageMessageContent _:
        return 'Image';
      case VideoMessageContent _:
        return 'Video';
      case FileMessageContent _:
        return 'Attachment';
      case StickerMessageContent _:
        return 'Sticker';
      default:
        return '';
    }
  }
}
