import '../../shared/commons/result.dart';
import '../entities/message/message.dart';

abstract class MessageRepository {
  Future<Result<List<MessageEntity>>> fetchPinnedMessages(
    int limit,
    int offset,
  );

  Future<Result<void>> unpinMessage(String messageId);
}
