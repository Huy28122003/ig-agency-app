import '../../shared/commons/result.dart';
import '../entities/message/message.dart';

abstract class MessageRepository {
  Future<Result<List<MessageEntity>>> getPinnedMessages(int limit, int offset);
}
