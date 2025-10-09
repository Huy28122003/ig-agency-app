import 'package:ig_agency_app/domain/entities/group_detail_entity.dart';
import '../entities/message/message.dart';
import '../entities/pinned_message_summary.dart';
import 'package:ig_agency_app/domain/entities/member_entity.dart';

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
}
