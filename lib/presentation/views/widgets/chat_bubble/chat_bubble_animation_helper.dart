import '../../../../shared/commons/constants/chat_bubble_constants.dart';

class ChatBubbleAnimationHelper {
  const ChatBubbleAnimationHelper({
    required this.isMe,
    required this.horizontalPadding,
  });

  final bool isMe;
  final double horizontalPadding;

  double getReplyIconOpacity(double dragDistance) {
    final absDistance = dragDistance.abs();
    if (absDistance < ChatBubbleConstants.replyIconThreshold) return 0.0;

    final maxDistance = horizontalPadding + ChatBubbleConstants.replyIconSize;
    final progress =
        (absDistance - ChatBubbleConstants.replyIconThreshold) /
        (maxDistance - ChatBubbleConstants.replyIconThreshold);
    return progress.clamp(0.0, 1.0);
  }

  double getAvatarOpacity(double dragDistance) {
    final absDistance = dragDistance.abs();

    if (absDistance >= ChatBubbleConstants.avatarHideThreshold) {
      return 0.0;
    }

    final progress = absDistance / ChatBubbleConstants.avatarHideThreshold;
    return (1.0 - progress).clamp(0.0, 1.0);
  }

  double getReplyIconOffset(double dragDistance) {
    final absDistance = dragDistance.abs();

    if (absDistance < ChatBubbleConstants.replyIconThreshold) {
      return isMe
          ? ChatBubbleConstants.replyIconSize
          : -ChatBubbleConstants.replyIconSize;
    }

    final maxDistance = horizontalPadding + ChatBubbleConstants.replyIconSize;

    if (absDistance >= maxDistance) {
      return 0;
    }

    final progress =
        (absDistance - ChatBubbleConstants.replyIconThreshold) /
        (maxDistance - ChatBubbleConstants.replyIconThreshold);
    final startOffset = isMe
        ? ChatBubbleConstants.replyIconSize
        : -ChatBubbleConstants.replyIconSize;
    final endOffset = 0.0;

    return startOffset + (endOffset - startOffset) * progress;
  }
}
