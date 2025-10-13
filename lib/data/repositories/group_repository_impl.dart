import 'package:ig_agency_app/data/remote/app/group_remote_data_source.dart';
import 'package:ig_agency_app/data/remote/translators/group_detail_translator.dart';
import 'package:ig_agency_app/domain/entities/group_detail_entity.dart';
import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:ig_agency_app/data/remote/translators/message_translator.dart';
import 'package:ig_agency_app/shared/utils/mock_data.dart';
import '../../domain/entities/message/message.dart';
import '../../domain/entities/pinned_message_summary.dart';
import '../../shared/commons/failure_converter.dart';
import '../remote/services/mock/message_mock_service.dart';
import '../../domain/entities/member_entity.dart';
import 'package:ig_agency_app/data/remote/translators/member_translator.dart';

@Injectable(as: GroupRepository)
class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl(this._groupRemoteDataSource, this._messageMockService);

  final GroupRemoteDataSource _groupRemoteDataSource;
  final MessageMockService _messageMockService;

  @override
  Future<GroupDetailEntity> getGroupDetail(String conversationId) async {
    try {
      final groupDetailResponse = await _groupRemoteDataSource.getGroupDetail(
        conversationId,
      );
      return groupDetailResponse.toEntity();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

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
      return await _groupRemoteDataSource.unpinMessage(groupId, messageId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future pinMessage(String groupId, String messageId) async {
    try {
      return await _groupRemoteDataSource.pinMessage(groupId, messageId);
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
      final pinnedMessages = await _groupRemoteDataSource.fetchPinnedMessage(
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
      final messages = await _groupRemoteDataSource.fetchMessagesInGroup(
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
  Future<MessageEntity> sendMessage(
    String groupId,
    String? clientMessageId,
    String? replyMessageId,
    MessageContent content,
  ) async {
    try {
      final messageResponse = await _groupRemoteDataSource.sendMessage(
        groupId,
        clientMessageId,
        replyMessageId,
        content,
      );
      return messageResponse.toEntity();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future deleteMessageForEveryone(String groupId, String messageId) async {
    try {
      await _groupRemoteDataSource.deleteMessageForEveryone(groupId, messageId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future deleteMessageForYou(String groupId, String messageId) async {
    try {
      await _groupRemoteDataSource.deleteMessageForYou(groupId, messageId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future deleteConversation(String groupId) async {
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

  @override
  Future<List<MemberEntity>> fetchMembersInGroup({
    required String groupId,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final membersResponse = await _groupRemoteDataSource.fetchMembersInGroup(
        groupId: groupId,
        limit: limit,
        offset: offset,
      );
      return membersResponse.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<MemberEntity>> searchMembersInGroup({
    required String groupId,
    required String query,
  }) async {
    try {
      final membersResponse = await _groupRemoteDataSource.searchMembersInGroup(
        groupId: groupId,
        query: query,
      );
      return membersResponse.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
