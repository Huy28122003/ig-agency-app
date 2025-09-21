import '../entities/message/message.dart';
import '../entities/pinned_message_summary.dart';

abstract class MessageRepository {
  Future<List<MessageEntity>> fetchPinnedMessages(int limit, int offset);

  Future unpinMessage(String messageId);

  Future pinMessage(String messageId);

  Future<PinnedMessageSummary> getPinnedMessageSummaryInGroup(int groupId);

  Future<List<MessageEntity>> fetchPinnedMessagesInGroup(
    int groupId,
    int limit,
    int offset,
  );

  Future<List<MessageEntity>> fetchMessagesInGroup(
    int groupId,
    int limit,
    String? oldestMessageId,
    String? targetMessageId,
  );

  Future<void> sendMessage(
    String userId,
    int groupId,
    String? replyMessageId,
    dynamic content,
  );

  Future<void> deleteMessageForEveryone(String messageId);

  Future<void> deleteMessageForYou(String messageId);

  Future<void> deleteConversation(int groupId);
}
