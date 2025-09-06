import '../entities/message/message.dart';
import '../entities/paged_result.dart';
import '../entities/pinned_message_summary.dart';

abstract class MessageRepository {
  Future<PagedResult<MessageEntity>> fetchPinnedMessages(int limit, int offset);

  Future unpinMessage(String messageId);

  Future<PinnedMessageSummary> getPinnedMessageSummaryByGroupId(int groupId);

  Future<PagedResult<MessageEntity>> fetchPinnedMessagesByGroupId(
    int groupId,
    int limit,
    int offset,
  );

  Future<PagedResult<MessageEntity>> fetchMessagesByGroupId(
    int groupId,
    int limit,
    String? oldestMessageId,
  );

  Future<MessageEntity> sendMessage(MessageEntity message);
}
