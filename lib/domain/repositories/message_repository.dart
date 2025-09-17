import '../entities/message/message.dart';
import '../entities/pinned_message_summary.dart';

abstract class MessageRepository {
  Future<List<MessageEntity>> fetchPinnedMessages(int limit, int offset);

  Future unpinMessage(String messageId);

  Future pinMessage(String messageId);

  Future<PinnedMessageSummary> getPinnedMessageSummaryInGroup(int workspaceId);

  Future<List<MessageEntity>> fetchPinnedMessagesInGroup(
    int workspaceId,
    int limit,
    int offset,
  );

  Future<List<MessageEntity>> fetchMessagesInGroup(
    int workspaceId,
    int limit,
    String? oldestMessageId,
    String? targetMessageId,
  );

  Future<void> sendMessage(
    String userId,
    int workspaceId,
    String? replyMessageId,
    dynamic content,
  );

  Future<void> deleteMessageForEveryone(String messageId);

  Future<void> deleteMessageForYou(String messageId);

  Future<void> deleteConversation(int workspaceId);
}
