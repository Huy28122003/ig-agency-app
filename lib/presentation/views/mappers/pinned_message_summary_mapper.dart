import '../../../domain/entities/pinned_message_summary.dart';
import '../../../domain/entities/message/message_content.dart';
import '../models/pinned_message_summary_ui_model.dart';

class PinnedMessageSummaryMapper {
  static PinnedMessageSummaryUiModel fromMessageEntity(
    PinnedMessageSummary entity,
  ) {
    final content = _extractContent(entity.latestMessage?.content);
    final senderName = content != null
        ? entity.latestMessage?.sender.name
        : null;
    return PinnedMessageSummaryUiModel(
      latestPinnedMessageContent: content,
      latestSenderName: senderName,
      totalPinnedMessages: entity.totalPinnedMessages,
    );
  }

  static String? _extractContent(MessageContent? content) {
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
}
