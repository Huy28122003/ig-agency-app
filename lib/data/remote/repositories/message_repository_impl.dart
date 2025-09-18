import 'package:dartx/dartx.dart';
import 'package:ig_agency_app/shared/utils/mock_data.dart';
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
  Future pinMessage(String messageId) async {
    try {
      // Todo: hoannk: rehandle this
      // TODO: Sử dụng tạm mock tại repository
      return await _messageMockService.mockPinMessage(messageId);
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
  Future<void> sendMessage(
    String userId,
    int workspaceId,
    String? replyMessageId,
    dynamic content,
  ) async {
    try {
      // Todo: hoannk: rehandle this
      // TODO: Sử dụng tạm mock tại repository
      await _messageMockService.addMessage(
        userId,
        workspaceId,
        replyMessageId,
        content,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<MessageEntity>> searchMessageInWorkspace({
    required int workspaceId,
    required String searchMessage,
    required int limit,
    required int offset,
  }) async {
    try {
      await 500.milliseconds.delay;
      return MockData().mockMessages().sublist(
        offset,
        offset + limit > MockData().mockMessages().length
            ? MockData().mockMessages().length
            : (offset + limit),
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
