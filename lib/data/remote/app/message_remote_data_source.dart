import '../../../domain/entities/message_entity.dart';

abstract class MessageRemoteDataSource {
  Future<List<MessageEntity>> getPinnedMessages(int limit, int offset);
}
