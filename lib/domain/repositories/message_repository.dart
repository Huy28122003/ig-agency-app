import '../../shared/commons/result.dart';
import '../entities/message/message.dart';
import '../entities/paged_result.dart';

abstract class MessageRepository {
  Future<Result<PagedResult<MessageEntity>>> fetchPinnedMessages(
    int limit,
    int offset,
  );

  Future<Result<void>> unpinMessage(String messageId);
}
