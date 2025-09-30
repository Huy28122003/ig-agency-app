import '../entities/message/message.dart';
import '../entities/pinned_message_summary.dart';

abstract class MessageRepository {
  Future<List<MessageEntity>> fetchPinnedMessages(int limit, int offset);

  Future unpinMessage(String messageId);

  Future pinMessage(String messageId);

  Future<PinnedMessageSummary> getPinnedMessageSummaryInGroup(String groupId);

  Future<List<MessageEntity>> fetchPinnedMessagesInGroup(
    String groupId,
    int limit,
    int offset,
  );

  Future<List<MessageEntity>> fetchMessagesInGroup(
    String groupId,
    int limit,
    String? oldestMessageId,
    String? targetMessageId,
  );

  Future<void> sendMessage(
    String userId,
    String groupId,
    String? replyMessageId,
    dynamic content,
  );

  Future<void> deleteMessageForEveryone(String messageId);

  Future<void> deleteMessageForYou(String messageId);

  Future<void> deleteConversation(String groupId);

  Future<List<MessageEntity>> searchMessageInWorkspace({
    required String workspaceId,
    required String searchMessage,
    int? limit,
    int? offset,
  });
}
