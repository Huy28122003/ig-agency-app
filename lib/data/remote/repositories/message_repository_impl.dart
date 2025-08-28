import 'package:injectable/injectable.dart';

import '../../../domain/entities/message_entity.dart';
import '../../../domain/repositories/message_repository.dart';
import '../../../shared/commons/failure_converter.dart';
import '../../../shared/commons/result.dart';
import '../app/message_remote_data_source.dart';

@Injectable(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl(this._messageRemoteDataSource);

  final MessageRemoteDataSource _messageRemoteDataSource;

  @override
  Future<Result<List<MessageEntity>>> getPinnedMessages(
    int limit,
    int offset,
  ) async {
    try {
      final messages = await _messageRemoteDataSource.getPinnedMessages(
        limit,
        offset,
      );
      return Result.completed(messages);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }
}
