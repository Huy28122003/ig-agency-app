import '../entities/message/message.dart';
import '../entities/paged_result.dart';
import '../entities/pinned_message_summary.dart';

abstract class MessageRepository {
  Future<PagedResult<MessageEntity>> fetchPinnedMessages(int limit, int offset);

  Future unpinMessage(String messageId);

  Future<PinnedMessageSummary> getPinnedMessageSummaryByWorkspaceId(
    int workspaceId,
  );

  Future<PagedResult<MessageEntity>> fetchPinnedMessagesByWorkspaceId(
    int workspaceId,
    int limit,
    int offset,
  );

  Future<PagedResult<MessageEntity>> fetchMessagesByWorkspaceId(
    int workspaceId,
    int limit,
    String? oldestMessageId,
    String? targetMessageId,
  );

  Future<MessageEntity> sendMessage(MessageEntity message);
}
