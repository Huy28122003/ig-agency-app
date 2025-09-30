import '../../../domain/entities/message/message.dart';

abstract class MessageRemoteDataSource {
  Future<List<MessageEntity>> fetchPinnedMessage(
    String groupId,
    int limit,
    int offset,
  );

  Future<void> unpinMessage(String groupId, String messageId);

  Future<void> pinMessage(String groupId, String messageId);
}
