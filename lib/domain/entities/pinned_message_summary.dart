import 'package:equatable/equatable.dart';

import 'message/message.dart';

class PinnedMessageSummary extends Equatable {
  const PinnedMessageSummary({
    this.recentPinnedMessage,
    required this.totalPinnedMessages,
  });

  final MessageEntity? recentPinnedMessage;
  final int totalPinnedMessages;

  PinnedMessageSummary copyWith({
    MessageEntity? recentPinnedMessage,
    int? totalPinnedMessages,
  }) {
    return PinnedMessageSummary(
      recentPinnedMessage: recentPinnedMessage ?? this.recentPinnedMessage,
      totalPinnedMessages: totalPinnedMessages ?? this.totalPinnedMessages,
    );
  }

  @override
  List<Object?> get props => [recentPinnedMessage, totalPinnedMessages];
}
