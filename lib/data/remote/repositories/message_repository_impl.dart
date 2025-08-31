import 'package:injectable/injectable.dart';

import '../../../domain/entities/message/message.dart';
import '../../../domain/entities/paged_result.dart';
import '../../../domain/repositories/message_repository.dart';
import '../../../shared/commons/failure_converter.dart';
import '../../../shared/commons/result.dart';
import '../app/message_remote_data_source.dart';
import '../translators/paging_translator.dart';

@Injectable(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl(this._messageRemoteDataSource);

  final MessageRemoteDataSource _messageRemoteDataSource;

  @override
  Future<Result<PagedResult<MessageEntity>>> fetchPinnedMessages(
    int limit,
    int offset,
  ) async {
    try {
      final pagingResponse = await _messageRemoteDataSource.fetchPinnedMessage(
        limit,
        offset,
      );

      final pageNumber = (offset / limit).floor() + 1;
      final pagedResult = PagingTranslator.fromPagingResponseModel(
        pagingResponse,
        pageNumber,
        limit,
      );

      return Result.completed(pagedResult);
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
