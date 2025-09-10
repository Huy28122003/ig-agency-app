import 'package:equatable/equatable.dart';
import 'package:ig_agency_app/domain/entities/message/message_entity.dart';
import 'package:ig_agency_app/domain/enums/message_enums.dart';

class ChatMessageUIModel extends Equatable {
  const ChatMessageUIModel({
    required this.message,
    this.shouldShowTime = false,
    this.shouldShowAvatar = false,
    this.shouldShowUserName = false,
    this.isContinuation = false,
  });

  final MessageEntity message;
  final bool shouldShowTime;
  final bool shouldShowAvatar;
  final bool shouldShowUserName;
  final bool isContinuation;

  ChatMessageUIModel copyWith({bool? shouldShowTime}) {
    return ChatMessageUIModel(
      message: message,
      shouldShowTime: shouldShowTime ?? this.shouldShowTime,
      shouldShowAvatar: shouldShowAvatar,
      shouldShowUserName: shouldShowUserName,
      isContinuation: isContinuation,
    );
  }

  @override
  List<Object?> get props => [
    message,
    shouldShowTime,
    shouldShowAvatar,
    shouldShowUserName,
    isContinuation,
  ];
}

extension ChatMessageUIModelMapper on MessageEntity {
  ChatMessageUIModel toUIModel({
    MessageEntity? previousMessage,
    MessageEntity? nextMessage,
    bool forceShowTime = false,
  }) {
    bool shouldShowTime = false;
    bool isContinuation = false;

    bool shouldShowAvatar = true;
    bool shouldShowUserName = true;

    final bool isSameDayAsPrevious =
        createdAt.day == previousMessage?.createdAt.day &&
        createdAt.month == previousMessage?.createdAt.month &&
        createdAt.year == previousMessage?.createdAt.year;

    if (!isSameDayAsPrevious || previousMessage == null) {
      shouldShowTime = true;
    }

    // System message
    if (type == MessageType.system) {
      if (previousMessage != null) {
        final bool isSameSystemTypeAsPrevious = type == previousMessage.type;

        // Same system type and same day
        if (isSameSystemTypeAsPrevious && isSameDayAsPrevious) {
          isContinuation = true;
        }
      }
    }
    // current message has not reply
    else if (reply == null) {
      // previous message has not reply and is not system message
      if (previousMessage != null &&
          previousMessage.reply == null &&
          previousMessage.type != MessageType.system) {
        final bool isSameSenderAsPrevious =
            sender.id == previousMessage.sender.id;
        final Duration timeDiffWithPrevious = createdAt.difference(
          previousMessage.createdAt,
        );
        final bool isWithinFiveMinutesWithPrevious =
            timeDiffWithPrevious.inMinutes <= 5;

        // Show time if not the same day
        if (!isSameDayAsPrevious) {
          shouldShowUserName = true;
        }
        // Same day, same sender, within 5 minutes with previous message
        else if (isSameSenderAsPrevious &&
            isSameDayAsPrevious &&
            isWithinFiveMinutesWithPrevious) {
          shouldShowUserName = false;
          isContinuation = true;
        } // Not same sender or not within 5 minutes with previous message, but same day
        else if ((!isSameSenderAsPrevious ||
                !isWithinFiveMinutesWithPrevious) &&
            isSameDayAsPrevious) {
          shouldShowUserName = true;
          isContinuation = false;
        }
      }
      // No previous message or previous message has reply or previous message is system message
      else {
        shouldShowUserName = true;
      }

      if (nextMessage != null &&
          nextMessage.reply == null &&
          nextMessage.type != MessageType.system) {
        final bool isSameSenderAsNext = sender.id == nextMessage.sender.id;
        final Duration timeDiffWithNext = nextMessage.createdAt.difference(
          createdAt,
        );
        final bool isWithinFiveMinutesWithNext =
            timeDiffWithNext.inMinutes <= 5;
        final bool isSameDayAsNext =
            createdAt.day == nextMessage.createdAt.day &&
            createdAt.month == nextMessage.createdAt.month &&
            createdAt.year == nextMessage.createdAt.year;

        // Same day, same sender, within 5 minutes with next message
        if (isSameSenderAsNext &&
            isSameDayAsNext &&
            isWithinFiveMinutesWithNext) {
          shouldShowAvatar = false;
        }
        // Not same sender or not within 5 minutes with next message
        else if (!isSameSenderAsNext || !isWithinFiveMinutesWithNext) {
          shouldShowAvatar = true;
        }
        // No next message or next message has reply or next message is system message
      } else {
        shouldShowAvatar = true;
      }

      // current message is the first message of the day
      if (shouldShowTime) {
        shouldShowUserName = true;
      }
    }

    return ChatMessageUIModel(
      message: this,
      shouldShowTime: forceShowTime ? true : shouldShowTime,
      shouldShowAvatar: shouldShowAvatar,
      shouldShowUserName: shouldShowUserName,
      isContinuation: isContinuation,
    );
  }
}
