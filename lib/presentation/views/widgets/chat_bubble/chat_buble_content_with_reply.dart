import 'package:flutter/material.dart';

import '../../../../domain/entities/message/message.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../shared/utils/text_message_display_util.dart';
import '../../../resources/colors.dart';
import 'chat_bubble_content.dart';

class ChatBubbleContentWithReply extends StatelessWidget {
  const ChatBubbleContentWithReply({
    super.key,
    required this.message,
    required this.replyMessage,
    required this.maxWidth,
    required this.maxWidthReply,
    required this.isMe,
    this.onTap,
  });

  final MessageEntity message;
  final MessageEntity replyMessage;
  final double maxWidth;
  final double maxWidthReply;
  final bool isMe;
  final Function(String messageId)? onTap;

  @override
  Widget build(BuildContext context) {
    String? text = getReplyText(replyMessage);
    if (text == null) return const SizedBox.shrink();

    final replyTextStyle = TextStyle(
      color: AppColors.textDefaultTextSub2,
      fontSize: 14,
      fontFamily: FontFamily.segoeUI,
      fontWeight: FontWeight.w400,
      height: 1.43,
    );
    final textLines = TextMessageDisplayUtil.calculateTextLines(
      text: text,
      maxWidth: maxWidthReply,
      style: replyTextStyle,
      maxLines: 2,
    );

    return Stack(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      children: [
        GestureDetector(
          onTap: () => onTap?.call(replyMessage.id),
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidthReply, maxHeight: 60),
            padding: const EdgeInsets.only(
              top: 8,
              left: 12,
              right: 12,
              bottom: 12,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: AppColors.surfaceContainerGrayStrong1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(12) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : Radius.circular(12),
                ),
              ),
            ),
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: replyTextStyle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: textLines > 1 ? 48 : 30),
          child: ChatBubbleContent(
            message: message,
            maxWidth: maxWidth,
            isMe: isMe,
          ),
        ),
      ],
    );
  }

  String? getReplyText(MessageEntity replyMessage) {
    final content = replyMessage.content;
    switch (content) {
      case TextMessageContent _:
        return content.text;
      case ImageMessageContent _:
        return 'Image';
      case VideoMessageContent _:
        return 'Video';
      case FileMessageContent _:
        return 'Attachment';
      default:
        return null;
    }
  }
}
