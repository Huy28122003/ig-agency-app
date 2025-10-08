import '../models/response/message_response_model.dart';

abstract class MessageRemoteDataSource {
  Future<List<MessageResponseModel>> fetchPinnedMessage(
    String groupId,
    int limit,
    int offset,
  );

  Future<void> unpinMessage(String groupId, String messageId);

  Future<void> pinMessage(String groupId, String messageId);
}
