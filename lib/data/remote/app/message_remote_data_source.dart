import '../../../domain/entities/message/message.dart';

abstract class MessageRemoteDataSource {
  Future<List<MessageEntity>> fetchPinnedMessage(
    String groupId,
    int limit,
    int offset,
    String? search,
    String? before,
  );

  Future<void> unpinMessage(String groupId, String messageId);

  Future<void> pinMessage(String groupId, String messageId);

  Future<List<MessageEntity>> fetchMessagesInGroup(
    String groupId,
    int limit,
    String? beforeMessageId,
    String? targetMessageId,
  );

  Future<void> sendMessage(
    String userId,
    String groupId,
    String? replyMessageId,
    MessageContent content,
  );

  Future<void> deleteMessageForEveryone(String groupId, String messageId);

  Future<void> deleteMessageForYou(String groupId, String messageId);
}
