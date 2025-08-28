import '../../shared/commons/result.dart';
import '../entities/message_entity.dart';

abstract class MessageRepository {
  Future<Result<List<MessageEntity>>> getPinnedMessages(int limit, int offset);
}
