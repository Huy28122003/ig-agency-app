import 'package:injectable/injectable.dart';

import '../../../domain/entities/message/message.dart';
import '../../../domain/repositories/message_repository.dart';
import '../../../shared/commons/failure_converter.dart';
import '../../../shared/commons/result.dart';
import '../app/message_remote_data_source.dart';

@Injectable(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl(this._messageRemoteDataSource);

  final MessageRemoteDataSource _messageRemoteDataSource;

  @override
  Future<Result<List<MessageEntity>>> fetchPinnedMessages(
    int limit,
    int offset,
  ) async {
    try {
      final messages = await _messageRemoteDataSource.fetchPinnedMessage(
        limit,
        offset,
      );
      return Result.completed(messages);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }

  @override
  Future<Result<void>> unpinMessage(String messageId) async {
    try {
      await _messageRemoteDataSource.unpinMessage(messageId);
      return Result.completed(null);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }
}
