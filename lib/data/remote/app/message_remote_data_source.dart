import '../../../domain/entities/message/message.dart';

abstract class MessageRemoteDataSource {
  Future<List<MessageEntity>> fetchPinnedMessage(int limit, int offset);

  Future<void> unpinMessage(String messageId);

  Future<void> sendMessage(
    String userId,
    String groupId,
    String? replyMessageId,
    MessageContent content,
  );
}
