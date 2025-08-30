import '../../../domain/entities/message/message.dart';

abstract class MessageRemoteDataSource {
  Future<List<MessageEntity>> getPinnedMessages(int limit, int offset);
}
