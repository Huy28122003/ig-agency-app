import 'package:injectable/injectable.dart';

import '../../../domain/entities/message/message.dart';
import '../../../domain/entities/paged_result.dart';
import '../../../domain/entities/pinned_message_summary.dart';
import '../../../domain/repositories/message_repository.dart';
import '../../../shared/commons/failure_converter.dart';
import '../app/message_remote_data_source.dart';
import '../services/mock/message_mock_service.dart';

@Injectable(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl(
    this._messageRemoteDataSource,
    this._messageMockService,
  );

  final MessageRemoteDataSource _messageRemoteDataSource;
  final MessageMockService _messageMockService;

  @override
  Future<PagedResult<MessageEntity>> fetchPinnedMessages(
    int limit,
    int offset,
  ) async {
    // Todo: hoannk: rehandle this
    // TODO: Sử dụng tạm mock tại repository
    try {
      final (pinnedMessages, totalRecords) = _messageMockService
          .mockFetchPinnedMessages(limit: limit, offset: offset);

      return PagedResult(data: pinnedMessages, totalRecords: totalRecords);
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

  @override
  Future<PagedResult<MessageEntity>> fetchPinnedMessagesByWorkspaceId(
    int workspaceId,
    int limit,
    int offset,
  ) async {
    // Todo: hoannk: rehandle this
    // TODO: Sử dụng tạm mock tại repository
    try {
      final (pinnedMessages, totalRecords) = _messageMockService
          .mockFetchPinnedMessages(
            groupId: workspaceId,
            limit: limit,
            offset: offset,
          );

      return PagedResult(data: pinnedMessages, totalRecords: totalRecords);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<PinnedMessageSummary> getPinnedMessageSummaryByWorkspaceId(
    int workspaceId,
  ) async {
    // Todo: hoannk: rehandle this
    // TODO: Sử dụng tạm mock tại repository
    try {
      final summary = _messageMockService.mockGetPinnedMessageSummary(
        workspaceId,
      );
      return summary;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<PagedResult<MessageEntity>> fetchMessagesByWorkspaceId(
    int workspaceId,
    int limit,
    String? oldestMessageId,
    String? targetMessageId,
  ) async {
    // Todo: hoannk: rehandle this
    // TODO: Sử dụng tạm mock tại repository
    try {
      final (messages, totalRecords) = _messageMockService
          .mockFetchMessagesByGroupId(
            groupId: workspaceId,
            limit: limit,
            oldestMessageId: oldestMessageId,
            targetMessageId: targetMessageId,
          );

      return PagedResult(data: messages, totalRecords: totalRecords);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<MessageEntity> sendMessage(MessageEntity message) async {
    try {
      // Todo: hoannk: rehandle this
      // TODO: Sử dụng tạm mock tại repository
      final sentMessage = await _messageMockService.addMessage(message);
      return sentMessage;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
