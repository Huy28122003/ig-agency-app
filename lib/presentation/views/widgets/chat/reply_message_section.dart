import 'package:flutter/material.dart';

import '../../../../domain/entities/message/message.dart';
import '../../../../domain/enums/message_enums.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../resources/colors.dart';
import '../network_image.dart';

class ReplyMessageSection extends StatelessWidget {
  const ReplyMessageSection({
    super.key,
    required this.isMe,
    required this.messageReply,
    this.onClose,
  });

  final bool isMe;
  final MessageEntity messageReply;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    String? previewText;
    Widget? previewWidget;
    switch (messageReply.type) {
      case MessageType.text:
        previewText = (messageReply.content as TextMessageContent).text;
        break;
      case MessageType.image:
        previewText = 'Image';
        previewWidget = NetworkImageWidget(
          imageUrl: (messageReply.content as ImageMessageContent).imageUrl,
          maxWidth: 40,
          maxHeight: 40,
          borderRadius: BorderRadius.circular(8),
        );
        break;
      case MessageType.video:
        previewText = 'Video';
        previewWidget = NetworkImageWidget(
          imageUrl:
              (messageReply.content as VideoMessageContent).thumbnailUrl ?? '',
          maxWidth: 40,
          maxHeight: 40,
          borderRadius: BorderRadius.circular(8),
        );
        break;
      case MessageType.file:
        previewText = 'Attachment';
        previewWidget = Assets.icons.icCircleDocumentPrimary.svg(
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        );
        break;
      default:
        previewText = '';
    }

    return Container(
      padding: const EdgeInsets.only(top: 8, left: 10, bottom: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: AppColors.surfaceContainerGrayStrong1),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  children: [
                    Text(
                      'Replying to ',
                      style: TextStyle(
                        color: AppColors.textDefaultTextDefault,
                        fontSize: 13,
                        fontFamily: FontFamily.segoeUI,
                        fontWeight: FontWeight.w400,
                        height: 1.23,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        isMe ? 'yourself' : messageReply.sender.name,
                        style: TextStyle(
                          color: AppColors.textDefaultTextDefault,
                          fontSize: 13,
                          fontFamily: FontFamily.segoeUI,
                          fontWeight: FontWeight.w700,
                          height: 1.23,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  previewText,
                  style: TextStyle(
                    color: AppColors.textDefaultTextDefault,
                    fontSize: 13,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w400,
                    height: 1.23,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (previewWidget != null) previewWidget,
          IconButton(
            padding: EdgeInsets.all(10),
            onPressed: onClose,
            icon: Assets.icons.icCloseCircle.svg(width: 24, height: 24),
          ),
        ],
      ),
    );
  }
}
