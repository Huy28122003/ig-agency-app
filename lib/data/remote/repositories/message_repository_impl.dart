import 'package:injectable/injectable.dart';

import '../../../domain/entities/message/message.dart';
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
  Future<List<MessageEntity>> fetchPinnedMessages(int limit, int offset) async {
    // Todo: hoannk: rehandle this
    // TODO: Sử dụng tạm mock tại repository
    try {
      final (pinnedMessages, totalRecords) = _messageMockService
          .mockFetchPinnedMessages(limit: limit, offset: offset);

      return pinnedMessages;
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
  Future<List<MessageEntity>> fetchPinnedMessagesInGroup(
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

      return pinnedMessages;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<PinnedMessageSummary> getPinnedMessageSummaryInGroup(
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
  Future<List<MessageEntity>> fetchMessagesInGroup(
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

      return messages;
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
  Future<void> deleteMessageForEveryone(String messageId) async {
    try {
      // Todo: hoannk: rehandle this
      // TODO: Sử dụng tạm mock tại repository
      await _messageMockService.mockDeleteMessageForEveryone(messageId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> deleteMessageForYou(String messageId) async {
    try {
      // Todo: hoannk: rehandle this
      // TODO: Sử dụng tạm mock tại repository
      await _messageMockService.mockDeleteMessageForYou(messageId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> deleteConversation(int workspaceId) async {
    try {
      // Todo: hoannk: rehandle this
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
