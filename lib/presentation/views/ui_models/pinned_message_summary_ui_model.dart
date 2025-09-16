import 'package:equatable/equatable.dart';
import 'package:ig_agency_app/domain/entities/message/message.dart';

import '../../../domain/entities/pinned_message_summary.dart';
import '../../../domain/entities/message/message_content.dart';

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

extension PinnedMessageSummaryUiModelMapper on PinnedMessageSummary {
  String? _extractContent(MessageContent? content) {
    if (content == null) return null;

    if (content is TextMessageContent) {
      return content.text;
    } else if (content is ImageMessageContent) {
      return 'Image';
    } else if (content is VideoMessageContent) {
      return 'Video';
    } else if (content is FileMessageContent) {
      return 'Attachment';
    }

    return null;
  }

  PinnedMessageSummaryUiModel toUIModel() {
    final content = _extractContent(latestMessage?.content);
    final senderName = content != null ? latestMessage?.sender.name : null;
    return PinnedMessageSummaryUiModel(
      latestPinnedMessageContent: content,
      latestSenderName: senderName,
      totalPinnedMessages: totalPinnedMessages,
    );
  }
}
