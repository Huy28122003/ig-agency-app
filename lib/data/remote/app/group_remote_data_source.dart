import 'package:ig_agency_app/data/remote/models/response/group_detail_response_model.dart';
import '../../../domain/entities/message/message.dart';
import '../models/requests/get_groups_request.dart';
import '../models/response/group_response.dart';
import '../models/response/group_summary_response.dart';
import '../models/response/message_response_model.dart';
import '../models/response/member_response_model.dart';

abstract class GroupRemoteDataSource {
  Future<GroupDetailResponseModel> getGroupDetail(String conversationId);

  Future<List<MessageResponseModel>> fetchPinnedMessage(
    String groupId,
    int limit,
    int offset,
  );

  Future unpinMessage(String groupId, String messageId);

  Future pinMessage(String groupId, String messageId);

  Future<List<MessageResponseModel>> fetchMessagesInGroup(
    String groupId,
    int limit,
    String? beforeMessageId,
    String? targetMessageId,
  );

  Future<MessageResponseModel> sendMessage(
    String groupId,
    String? clientMessageId,
    String? replyMessageId,
    MessageContent content,
  );

  Future deleteMessageForEveryone(String groupId, String messageId);

  Future deleteMessageForYou(String groupId, String messageId);

  Future<List<MemberResponseModel>> fetchMembersInGroup({
    required String groupId,
    int limit = 10,
    int offset = 0,
  });

  Future<List<MemberResponseModel>> searchMembersInGroup({
    required String groupId,
    required String query,
  });

  Future<List<GroupSummaryResponse>> getGroups({
    required GetGroupsRequest getWorkspacesRequest,
  });

  Future<void> pinGroup(String groupId);

  Future<void> unpinGroup(String groupId);

  Future<void> deleteGroup(String groupId);

  Future<GroupResponse> getGroupInfo(String groupId);

  Future<void> updateGroupInfo(
    String groupId, {
    String? bio,
    String? name,
    String? image,
  });

  Future<void> markAsRead(String groupId);

  Future<void> markUnread(String groupId);
}
