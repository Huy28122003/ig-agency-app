import 'package:ig_agency_app/data/remote/models/response/group_detail_response_model.dart';
import '../../../domain/entities/message/message.dart';
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
}
