import 'package:dartx/dartx.dart';
import 'package:ig_agency_app/shared/utils/mock_data.dart';
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
      final pinnedMessages = _messageMockService.mockFetchPinnedMessages(
        limit: limit,
        offset: offset,
      );

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
    int groupId,
    int limit,
    int offset,
  ) async {
    // Todo: hoannk: rehandle this
    // TODO: Sử dụng tạm mock tại repository
    try {
      final pinnedMessages = _messageMockService.mockFetchPinnedMessages(
        groupId: groupId,
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
    int groupId,
  ) async {
    // Todo: hoannk: rehandle this
    // TODO: Sử dụng tạm mock tại repository
    try {
      final summary = _messageMockService.mockGetPinnedMessageSummary(groupId);
      return summary;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<MessageEntity>> fetchMessagesInGroup(
    int groupId,
    int limit,
    String? oldestMessageId,
    String? targetMessageId,
  ) async {
    // Todo: hoannk: rehandle this
    // TODO: Sử dụng tạm mock tại repository
    try {
      final messages = _messageMockService.mockFetchMessagesByGroupId(
        groupId: groupId,
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
    int groupId,
    String? replyMessageId,
    dynamic content,
  ) async {
    try {
      // Todo: hoannk: rehandle this
      // TODO: Sử dụng tạm mock tại repository
      await _messageMockService.addMessage(
        userId,
        groupId,
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
  Future<void> deleteConversation(int groupId) async {
    try {
      // Todo: hoannk: rehandle this
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
