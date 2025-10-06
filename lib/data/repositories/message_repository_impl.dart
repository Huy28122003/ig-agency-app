import 'package:dartx/dartx.dart';
import 'package:ig_agency_app/data/remote/translators/message_translator.dart';
import 'package:ig_agency_app/shared/utils/mock_data.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/message/message.dart';
import '../../domain/entities/pinned_message_summary.dart';
import '../../domain/repositories/message_repository.dart';
import '../../shared/commons/failure_converter.dart';
import '../remote/app/message_remote_data_source.dart';
import '../remote/services/mock/message_mock_service.dart';

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
  Future unpinMessage(String groupId, String messageId) async {
    try {
      return await _messageRemoteDataSource.unpinMessage(groupId, messageId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future pinMessage(String groupId, String messageId) async {
    try {
      return await _messageRemoteDataSource.pinMessage(groupId, messageId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<MessageEntity>> fetchPinnedMessagesInGroup(
    String groupId,
    int limit,
    int offset,
  ) async {
    try {
      final pinnedMessages = await _messageRemoteDataSource.fetchPinnedMessage(
        groupId,
        limit,
        offset,
      );

      return pinnedMessages.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<PinnedMessageSummary> getPinnedMessageSummaryInGroup(
    String groupId,
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
    String groupId,
    int limit,
    String? beforeMessageId,
    String? targetMessageId,
  ) async {
    try {
      final messages = await _messageRemoteDataSource.fetchMessagesInGroup(
        groupId,
        limit,
        beforeMessageId,
        targetMessageId,
      );

      return messages.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> sendMessage(
    String userId,
    String groupId,
    String? replyMessageId,
    MessageContent content,
  ) async {
    try {
      await _messageRemoteDataSource.sendMessage(
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
  Future<void> deleteMessageForEveryone(
    String groupId,
    String messageId,
  ) async {
    try {
      await _messageRemoteDataSource.deleteMessageForEveryone(
        groupId,
        messageId,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> deleteMessageForYou(String groupId, String messageId) async {
    try {
      await _messageRemoteDataSource.deleteMessageForYou(groupId, messageId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> deleteConversation(String groupId) async {
    try {
      // Todo: hoannk: rehandle this
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<MessageEntity>> searchMessageInWorkspace({
    required String workspaceId,
    required String searchMessage,
    int? limit,
    int? offset,
  }) async {
    try {
      final start = offset ?? 0;
      final end = start + (limit ?? MockData().mockMessages().length);
      await 500.milliseconds.delay;
      return MockData().mockMessages().sublist(
        start,
        end > MockData().mockMessages().length
            ? MockData().mockMessages().length
            : (end),
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
