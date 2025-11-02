import 'package:ig_agency_app/domain/entities/group_detail_entity.dart';
import '../../shared/commons/models/pagination.dart';
import '../entities/file_entity.dart';
import '../entities/group_entity.dart';
import '../entities/group_summary.dart';
import '../entities/media_entity.dart';
import '../entities/message/message.dart';
import '../entities/pinned_message_summary.dart';
import 'package:ig_agency_app/domain/entities/member_entity.dart';

import '../entities/user_entity.dart';
import '../enums/unmute_time_enum.dart';

abstract class GroupRepository {
  Future<GroupDetailEntity> getGroupDetail(String conversationId);

  Future<List<MessageEntity>> fetchPinnedMessages(int limit, int offset);

  Future unpinMessage(String groupId, String messageId);

  Future pinMessage(String groupId, String messageId);

  Future<PinnedMessageSummary> getPinnedMessageSummaryInGroup(String groupId);

  Future<List<MessageEntity>> fetchPinnedMessagesInGroup(
    String groupId,
    int limit,
    int offset,
  );

  Future<List<MessageEntity>> fetchMessagesInGroup(
    String groupId,
    int limit,
    String? beforeMessageId,
    String? targetMessageId,
  );

  Future<MessageEntity> sendMessage(
    String groupId,
    String? clientMessageId,
    String? replyMessageId,
    MessageContent content,
  );

  Future<void> deleteMessageForEveryone(String groupId, String messageId);

  Future<void> deleteMessageForYou(String groupId, String messageId);

  Future<void> deleteConversation(String groupId);

  Future<List<MessageEntity>> searchMessageInWorkspace({
    required String workspaceId,
    required String searchMessage,
    int? limit,
    int? offset,
  });

  Future<List<MemberEntity>> fetchMembersInGroup({
    required String groupId,
    int limit = 10,
    int offset = 0,
  });

  Future<List<MemberEntity>> searchMembersInGroup({
    required String groupId,
    required String query,
  });

  Future<List<GroupSummary>> getGroups({
    required int limit,
    required int offset,
    String? keyWord,
  });

  Future<GroupEntity> getGroupInfo({required String groupId});

  Stream<GroupEntity> listenLastMessages();

  Future<bool> updateGroupBio({required String groupId, required String bio});

  Future<bool> updateGroupName({required String groupId, required String name});

  Future<List<UserEntity>> getUserInGroup({
    required String workspaceId,
    required int offset,
    required int limit,
  });

  Future<bool> updateGroupNotification({
    required String groupId,
    required bool isMute,
  });

  Future<List<MediaEntity>> getMediasInGroup({
    required String workspaceId,
    required int offset,
    required int limit,
  });

  Future<List<FileEntity>> getFileInGroup({
    required String workspaceId,
    required int offset,
    required int limit,
  });

  Future<List<String>> getLinkInGroup({
    required String workspaceId,
    required int offset,
    required int limit,
  });

  Future<List<UserEntity>> getListUser({
    required Pagination pagination,
    String? keySearch,
  });

  // TODO: tương tự hàm getWorkspaces => quy về dùng chung 1 hàm
  Future<List<GroupEntity>> getListGroup({
    required Pagination pagination,
    String? keySearch,
  });

  Future<bool> createGroup(String groupName, List<UserEntity> members);

  Future<bool> addUserToGroups(UserEntity user, List<GroupEntity> groups);

  Future<void> pinGroup(String workspaceId);

  Future<void> unpinGroup(String workspaceId);

  Future<void> deleteGroup(String workspaceId);

  Future<void> markAsRead(String groupId);

  Future<void> markUnread(String groupId);

  Future<void> changeNotificationStatus({
    required String groupId,
    required bool enable,
    MuteDurationOption? option,
  });
}
