import '../../../domain/entities/message/message.dart';
import '../models/response/paged_response.dart';

abstract class MessageRemoteDataSource {
  Future<PagedResponse<MessageEntity>> fetchPinnedMessage(
    int limit,
    int offset,
  );

  Future<void> unpinMessage(String messageId);
}
