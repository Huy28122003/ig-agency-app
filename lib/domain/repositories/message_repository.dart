import '../../shared/commons/result.dart';
import '../entities/message/message.dart';
import '../entities/paged_result.dart';

abstract class MessageRepository {
  Future<PagedResult<MessageEntity>> fetchPinnedMessages(int limit, int offset);

  Future unpinMessage(String messageId);
}
