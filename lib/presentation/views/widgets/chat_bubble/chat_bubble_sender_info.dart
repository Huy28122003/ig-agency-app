import 'package:flutter/material.dart';
import '../../../../domain/entities/message/message.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../resources/colors.dart';

class ChatBubbleSenderInfo extends StatelessWidget {
  const ChatBubbleSenderInfo({
    super.key,
    required this.message,
    required this.isMe,
    this.userId,
  });

  final MessageEntity message;
  final String? userId;
  final bool isMe;

  bool get replyMessageSenderIdIsMe =>
      userId == message.repliedMessage?.user.id;

  @override
  Widget build(BuildContext context) {
    final MessageEntity? reply = message.repliedMessage;
    final bool hasReply = reply != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasReply) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  isMe ? 'You' : message.user.name,
                  style: const TextStyle(
                    color: AppColors.textDefaultTextSub2,
                    fontSize: 12,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Text(
                ' replying to ',
                style: TextStyle(
                  color: AppColors.textDefaultTextSub2,
                  fontSize: 12,
                  fontFamily: FontFamily.segoeUI,
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                ),
              ),
              Flexible(
                child: Text(
                  isMe
                      ? 'yourself'
                      : replyMessageSenderIdIsMe
                      ? 'you'
                      : reply.user.name,
                  style: const TextStyle(
                    color: AppColors.textDefaultTextSub2,
                    fontSize: 12,
                    fontFamily: FontFamily.segoeUI,
                    fontWeight: FontWeight.w700,
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
        ] else
          Text(
            message.user.name,
            style: const TextStyle(
              color: AppColors.textDefaultTextSub2,
              fontSize: 12,
              fontFamily: FontFamily.segoeUI,
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
        const SizedBox(height: 4),
      ],
    );
  }
}
