import 'package:injectable/injectable.dart';

import '../../../domain/entities/message/message.dart';
import '../../../domain/entities/paged_result.dart';
import '../../../domain/repositories/message_repository.dart';
import '../../../shared/commons/failure_converter.dart';
import '../app/message_remote_data_source.dart';
import '../translators/paging_translator.dart';

@Injectable(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl(this._messageRemoteDataSource);

  final MessageRemoteDataSource _messageRemoteDataSource;

  @override
  Future<PagedResult<MessageEntity>> fetchPinnedMessages(
    int limit,
    int offset,
  ) async {
    // Todo: hoannk: rehandle this
    try {
      final pagingResponse = await _messageRemoteDataSource.fetchPinnedMessage(
        limit,
        offset,
      );
      return PagingTranslator.toEntity(pagingResponse, (response) => response);

      // final pagedResult = PagingTranslator.toEntity(pagingResponse.records);
      //
      // return Result.completed(pagedResult);
      return PagedResult(data: [], totalRecords: 0);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future unpinMessage(String messageId) async {
    try {
      return await _messageRemoteDataSource.unpinMessage(messageId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
