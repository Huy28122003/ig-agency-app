import 'package:equatable/equatable.dart';

class PinnedMessageSummaryUiModel extends Equatable {
  const PinnedMessageSummaryUiModel({
    this.latestPinnedMessageContent,
    this.latestSenderName,
    required this.totalPinnedMessages,
  });

  final String? latestPinnedMessageContent;
  final String? latestSenderName;
  final int totalPinnedMessages;

  bool get hasPinnedMessages =>
      latestPinnedMessageContent != null &&
      latestSenderName != null &&
      totalPinnedMessages > 0;

  bool get hasMorePinnedMessages =>
      hasPinnedMessages && totalPinnedMessages > 1;

  PinnedMessageSummaryUiModel copyWith({
    String? latestPinnedMessageContent,
    String? latestSenderName,
    int? totalPinnedMessages,
  }) {
    return PinnedMessageSummaryUiModel(
      latestPinnedMessageContent:
          latestPinnedMessageContent ?? this.latestPinnedMessageContent,
      latestSenderName: latestSenderName ?? this.latestSenderName,
      totalPinnedMessages: totalPinnedMessages ?? this.totalPinnedMessages,
    );
  }

  @override
  List<Object?> get props => [
    latestPinnedMessageContent,
    latestSenderName,
    totalPinnedMessages,
  ];
}
