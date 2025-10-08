import '../../../domain/entities/message/message_content.dart';
import '../models/response/message_response_model.dart';

abstract class MessageRemoteDataSource {
  Future<List<MessageResponseModel>> fetchPinnedMessage(String groupId,
      int limit,
      int offset,);

  Future<void> unpinMessage(String groupId, String messageId);

  Future<void> pinMessage(String groupId, String messageId);

  Future<List<MessageResponseModel>> fetchMessagesInGroup(String groupId,
      int limit,
      String? beforeMessageId,
      String? targetMessageId,);

  Future<void> sendMessage(String groupId,
      String? clientMessageId,
      String? replyMessageId,
      MessageContent content,);

  Future<void> deleteMessageForEveryone(String groupId, String messageId);

  Future<void> deleteMessageForYou(String groupId, String messageId);
}
