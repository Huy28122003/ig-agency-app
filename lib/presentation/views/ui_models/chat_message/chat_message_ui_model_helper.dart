import '../../../../domain/enums/message_enums.dart';
import 'chat_message_ui_model.dart';

class ChatMessageHelper {
  static (
    bool shouldShowTime,
    bool shouldShowAvatar,
    bool shouldShowUserName,
    bool isContinuation,
  )
  updateUIModel({
    required ChatMessageUIModel currentMessage,
    ChatMessageUIModel? previousMessage,
    ChatMessageUIModel? nextMessage,
  }) {
    final bool shouldShowTime = currentMessage.shouldShowTime;
    bool isContinuation = false;

    bool shouldShowAvatar = true;
    bool shouldShowUserName = true;

    final bool isSameDayAsPrevious =
        currentMessage.message.createdAt.day ==
            previousMessage?.message.createdAt.day &&
        currentMessage.message.createdAt.month ==
            previousMessage?.message.createdAt.month &&
        currentMessage.message.createdAt.year ==
            previousMessage?.message.createdAt.year;

    // System message
    if (currentMessage.message.type == MessageType.system) {
      final bool isSameSystemTypeAsPrevious =
          currentMessage.message.type == previousMessage?.message.type;

      // Same system type and same day
      if (isSameSystemTypeAsPrevious && isSameDayAsPrevious) {
        isContinuation = true;
      }
    }
    // current message has not reply
    else if (currentMessage.message.reply == null) {
      // previous message has not reply and is not system message
      final previous = previousMessage?.message;
      if (previous != null &&
          previous.reply == null &&
          previous.type != MessageType.system) {
        final bool isSameSenderAsPrevious =
            currentMessage.message.sender.id == previous.sender.id;
        final Duration timeDiffWithPrevious = currentMessage.message.createdAt
            .difference(previous.createdAt);
        final bool isWithinFiveMinutesWithPrevious =
            timeDiffWithPrevious.inMinutes <= 5;

        // Show time if not the same day
        if (!isSameDayAsPrevious) {
          shouldShowUserName = true;
        }
        // Same day, same sender, within 5 minutes with previous message, and not show time
        else if (isSameSenderAsPrevious &&
            isSameDayAsPrevious &&
            isWithinFiveMinutesWithPrevious &&
            !shouldShowTime) {
          shouldShowUserName = false;
          isContinuation = true;
        } // Not same sender or not within 5 minutes with previous message, but same day
        else if ((!isSameSenderAsPrevious ||
                !isWithinFiveMinutesWithPrevious ||
                shouldShowTime) &&
            isSameDayAsPrevious) {
          shouldShowUserName = true;
          isContinuation = false;
        }
      }
      // No previous message or previous message has reply or previous message is system message
      else {
        shouldShowUserName = true;
      }

      final next = nextMessage?.message;
      if (next != null &&
          next.reply == null &&
          next.type != MessageType.system) {
        final bool isSameSenderAsNext =
            currentMessage.message.sender.id == next.sender.id;
        final Duration timeDiffWithNext = next.createdAt.difference(
          currentMessage.message.createdAt,
        );
        final bool isWithinFiveMinutesWithNext =
            timeDiffWithNext.inMinutes <= 5;
        final bool isSameDayAsNext =
            currentMessage.message.createdAt.day == next.createdAt.day &&
            currentMessage.message.createdAt.month == next.createdAt.month &&
            currentMessage.message.createdAt.year == next.createdAt.year;

        // Same day, same sender, within 5 minutes with next message, and not show time
        if (isSameSenderAsNext &&
            isSameDayAsNext &&
            isWithinFiveMinutesWithNext &&
            !shouldShowTime) {
          shouldShowAvatar = false;
        }
        // Not same sender or not within 5 minutes or show time with next message
        else if (!isSameSenderAsNext ||
            !isWithinFiveMinutesWithNext ||
            shouldShowTime) {
          shouldShowAvatar = true;
        }
        // No next message or next message has reply or next message is system message
      } else {
        shouldShowAvatar = true;
      }

      // current message is the first message of the day or show time
      if (shouldShowTime) {
        shouldShowUserName = true;
      }
    }

    return (
      shouldShowTime,
      shouldShowAvatar,
      shouldShowUserName,
      isContinuation,
    );
  }
}
