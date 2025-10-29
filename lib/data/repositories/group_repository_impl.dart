import 'package:ig_agency_app/data/remote/app/group_remote_data_source.dart';
import 'package:ig_agency_app/data/remote/translators/group_detail_translator.dart';
import 'package:ig_agency_app/data/remote/translators/group_summary_translator.dart';
import 'package:ig_agency_app/domain/entities/group_detail_entity.dart';
import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:ig_agency_app/data/remote/translators/message_translator.dart';
import 'package:ig_agency_app/shared/utils/mock_data.dart';
import '../../domain/entities/file_entity.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/group_summary.dart';
import '../../domain/entities/media_entity.dart';
import '../../domain/entities/message/message.dart';
import '../../domain/entities/pinned_message_summary.dart';
import '../../domain/entities/user_entity.dart';
import '../../shared/commons/failure_converter.dart';
import '../../shared/commons/models/pagination.dart';
import '../remote/models/requests/get_groups_request.dart';
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

  @override
  Future<List<GroupSummary>> getGroups({
    required int limit,
    required int offset,
    String? keyWord,
  }) async {
    try {
      final response = await _groupRemoteDataSource.getGroups(
        getWorkspacesRequest: GetGroupsRequest(
          limit: limit,
          offset: offset,
          search: keyWord,
        ),
      );
      return response.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Stream<GroupEntity> listenLastMessages() {
    // TODO: implement listenLastMessages
    throw UnimplementedError();
  }

  @override
  Future<GroupEntity> getGroupInfo({required String groupId}) async {
    try {
      final workspace = MockData.getWorkspaces().firstWhere(
        (element) => element.id == groupId,
      );
      return workspace;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<bool> updateGroupBio({
    required String groupId,
    required String bio,
  }) async {
    try {
      return true;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<bool> updateGroupName({
    required String groupId,
    required String name,
  }) async {
    try {
      return true;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<bool> updateGroupNotification({
    required String groupId,
    required bool isMute,
  }) async {
    try {
      return true;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<bool> createGroup(String groupName, List<UserEntity> members) {
    return Future.value(true);
  }

  @override
  Future<List<UserEntity>> getListUser({
    required Pagination pagination,
    String? keySearch,
  }) {
    return Future.value([
      UserEntity(id: "1", name: "Pham Phu", isAdmin: false),
      UserEntity(id: "2", name: "Nguyen Van A", isAdmin: false),
      UserEntity(id: "3", name: "Le Thi B", isAdmin: false),
      UserEntity(id: "4", name: "Tran Van C", isAdmin: false),
      UserEntity(id: "5", name: "Hoang Thi D", isAdmin: false),
      UserEntity(id: "6", name: "Vu Van E", isAdmin: false),
      UserEntity(id: "7", name: "Pham Thi F", isAdmin: false),
      UserEntity(id: "8", name: "Nguyen Van G", isAdmin: false),
      UserEntity(id: "9", name: "Le Thi H", isAdmin: false),
      UserEntity(id: "10", name: "Tran Van I", isAdmin: false),
      UserEntity(id: "11", name: "Hoang Thi K", isAdmin: false),
      UserEntity(id: "12", name: "Vu Van L", isAdmin: false),
      UserEntity(id: "13", name: "Pham Thi M", isAdmin: false),
      UserEntity(id: "14", name: "Nguyen Van N", isAdmin: false),
      UserEntity(id: "15", name: "Le Thi O", isAdmin: false),
      UserEntity(id: "16", name: "Tran Van P", isAdmin: false),
      UserEntity(id: "17", name: "Hoang Thi Q", isAdmin: false),
      UserEntity(id: "18", name: "Vu Van R", isAdmin: false),
    ]);
  }

  @override
  Future<bool> addUserToGroups(UserEntity user, List<GroupEntity> groups) {
    return Future.value(true);
  }

  @override
  Future<List<GroupEntity>> getListGroup({
    required Pagination pagination,
    String? keySearch,
  }) {
    try {
      final allData = MockData.getWorkspaces();

      final filtered = keySearch != null && keySearch.isNotEmpty
          ? allData
                .where(
                  (e) => e.groupName.toLowerCase().contains(
                    keySearch.toLowerCase(),
                  ),
                )
                .toList()
          : allData;

      return Future.value(filtered);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<UserEntity>> getUserInGroup({
    required String workspaceId,
    required int offset,
    required int limit,
  }) async {
    try {
      return MockData().users.sublist(
        offset,
        offset + limit > MockData().users.length
            ? MockData().users.length
            : offset + limit,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<MediaEntity>> getMediasInGroup({
    required String workspaceId,
    required int offset,
    required int limit,
  }) async {
    try {
      return MockData().mockMediaData.sublist(
        offset,
        offset + limit > MockData().mockMediaData.length
            ? MockData().mockMediaData.length
            : offset + limit,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<FileEntity>> getFileInGroup({
    required String workspaceId,
    required int offset,
    required int limit,
  }) async {
    try {
      return MockData().mockFileEntities().sublist(
        offset,
        offset + limit > MockData().mockFileEntities().length
            ? MockData().mockFileEntities().length
            : offset + limit,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<String>> getLinkInGroup({
    required String workspaceId,
    required int offset,
    required int limit,
  }) async {
    try {
      return MockData().mockLinks.sublist(
        offset,
        offset + limit > MockData().mockLinks.length
            ? MockData().mockLinks.length
            : offset + limit,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> pinGroup(String workspaceId) async {
    try {
      await _groupRemoteDataSource.pinGroup(workspaceId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> unpinGroup(String workspaceId) async {
    try {
      await _groupRemoteDataSource.unpinGroup(workspaceId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> deleteGroup(String workspaceId) async {
    try {
      await _groupRemoteDataSource.deleteGroup(workspaceId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> markAsRead(String groupId) async {
    try {
      await _groupRemoteDataSource.markAsRead(groupId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> markUnread(String groupId) async {
    try {
      await _groupRemoteDataSource.markUnread(groupId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> changeNotificationStatus({
    required String groupId,
    required bool enable,
    String? unMuteTimeCode,
  }) async {
    try {
      await _groupRemoteDataSource.changeNotificationStatus(
        groupId: groupId,
        enable: enable,
        unMuteTimeCode: unMuteTimeCode,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
