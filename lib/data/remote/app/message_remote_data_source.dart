import '../../../domain/entities/message/message.dart';
import '../models/response/paging_response_model.dart';

abstract class MessageRemoteDataSource {
  Future<PagingResponseModel<MessageEntity>> fetchPinnedMessage(
    int limit,
    int offset,
  );

  Future<void> unpinMessage(String messageId);
}
