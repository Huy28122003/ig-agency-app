import 'package:flutter/material.dart';
import '../../../../gen/assets.gen.dart';
import '../../../resources/colors.dart';
import '../../../../shared/commons/constants/chat_bubble_constants.dart';

class ReplyIcon extends StatelessWidget {
  const ReplyIcon({
    super.key,
    required this.opacity,
    required this.offset,
    required this.isMe,
    required this.horizontalPadding,
  });

  final double opacity;
  final double offset;
  final bool isMe;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    if (opacity == 0.0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 0 : horizontalPadding,
        right: isMe ? horizontalPadding : 0,
      ),
      child: Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(offset, 0),
          child: Container(
            height: ChatBubbleConstants.replyIconSize,
            width: ChatBubbleConstants.replyIconSize,
            alignment: Alignment.center,
            decoration: const ShapeDecoration(
              color: AppColors.surfaceContainerGrayStrong2,
              shape: CircleBorder(),
            ),
            child: Assets.icons.icReply.svg(width: 16, height: 16),
          ),
        ),
      ),
    );
  }
}
