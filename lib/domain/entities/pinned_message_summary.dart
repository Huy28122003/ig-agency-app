import 'package:equatable/equatable.dart';

import 'message/message.dart';

class PinnedMessageSummary extends Equatable {
  const PinnedMessageSummary({
    this.latestMessage,
    required this.totalPinnedMessages,
  });

  final MessageEntity? latestMessage;
  final int totalPinnedMessages;

  PinnedMessageSummary copyWith({
    MessageEntity? latestMessage,
    int? totalPinnedMessages,
  }) {
    return PinnedMessageSummary(
      latestMessage: latestMessage ?? this.latestMessage,
      totalPinnedMessages: totalPinnedMessages ?? this.totalPinnedMessages,
    );
  }

  @override
  List<Object?> get props => [latestMessage, totalPinnedMessages];
}
