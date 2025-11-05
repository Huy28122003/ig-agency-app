import 'package:dio/dio.dart';
import 'package:ig_agency_app/data/remote/app/group_remote_data_source.dart';
import 'package:ig_agency_app/data/remote/models/requests/change_notification_status_request.dart';
import 'package:ig_agency_app/data/remote/models/requests/update_group_info_request.dart';
import 'package:ig_agency_app/data/remote/models/response/group_detail_response_model.dart';
import 'package:ig_agency_app/data/remote/models/response/update_group_avatar_response.dart';
import 'package:ig_agency_app/data/remote/services/api_services.dart';
import 'package:ig_agency_app/shared/commons/exception_converter.dart';
import 'package:ig_agency_app/shared/commons/exceptions.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';
import 'package:injectable/injectable.dart';
import 'package:ig_agency_app/data/remote/models/requests/pin_message_request_model.dart';
import '../../../domain/entities/message/message_content.dart';
import '../../../domain/enums/message_enums.dart';
import '../models/requests/get_groups_request.dart';
import '../models/requests/send_message_request_model.dart';
import '../models/requests/delete_message_request_model.dart';
import '../models/response/group_response.dart';
import '../models/response/group_summary_response.dart';
import '../models/response/message_response_model.dart';
import '../models/response/member_response_model.dart';

@Injectable(as: GroupRemoteDataSource)
class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  GroupRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<GroupDetailResponseModel> getGroupDetail(String conversationId) async {
    try {
      final groupDetail = await _apiService.getGroupDetail(conversationId);
      return groupDetail;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<List<MessageResponseModel>> fetchPinnedMessage(
    String groupId,
    int limit,
    int offset,
  ) async {
    try {
      final pinnedMessages = await _apiService.getPinnedMessages(
        groupId,
        limit,
        offset,
      );

      return pinnedMessages;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> unpinMessage(String groupId, String messageId) async {
    try {
      await _apiService.unpinMessage(groupId, messageId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> pinMessage(String groupId, String messageId) async {
    try {
      await _apiService.pinMessage(
        groupId,
        PinMessageRequestModel(messageId: messageId),
      );
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<MessageResponseModel> sendMessage(
    String groupId,
    String? clientMessageId,
    String? replyMessageId,
    MessageContent content,
  ) async {
    try {
      if (content is TextMessageContent) {
        final messageResponse = await _apiService.sendMessage(
          groupId,
          SendMessageRequestModel(
            type: MessageContentType.text.code,
            clientMessageId: clientMessageId,
            text: content.text,
            replyToMessageId: replyMessageId,
          ),
        );
        return messageResponse;
      } else {
        throw Exception('Unsupported content type');
      }
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<List<MessageResponseModel>> fetchMessagesInGroup(
    String groupId,
    int limit,
    String? beforeMessageId,
    String? targetMessageId,
  ) async {
    final messages = await _apiService.getMessages(
      groupId,
      limit,
      beforeMessageId,
    );

    return messages;
  }

  @override
  Future<void> deleteMessageForEveryone(
    String groupId,
    String messageId,
  ) async {
    try {
      await _apiService.deleteMessage(
        groupId,
        messageId,
        const DeleteMessageRequestModel(deleteForAllMember: true),
      );
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> deleteMessageForYou(String groupId, String messageId) async {
    try {
      await _apiService.deleteMessage(
        groupId,
        messageId,
        const DeleteMessageRequestModel(deleteForAllMember: false),
      );
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<List<MemberResponseModel>> fetchMembersInGroup({
    required String groupId,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final members = await _apiService.getMembersInGroup(
        groupId,
        limit,
        offset,
      );
      return members;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<List<MemberResponseModel>> searchMembersInGroup({
    required String groupId,
    required String query,
  }) async {
    try {
      final members = await _apiService.searchMembersInGroup(groupId, query);
      return members;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<List<GroupSummaryResponse>> getGroups({
    required GetGroupsRequest getWorkspacesRequest,
  }) async {
    try {
      return await _apiService.getGroups(getWorkspacesRequest);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> pinGroup(String groupId) async {
    try {
      return await _apiService.pinGroup(groupId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> unpinGroup(String groupId) async {
    try {
      return await _apiService.unpinGroup(groupId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    try {
      return await _apiService.deleteGroup(groupId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<GroupResponse> getGroupInfo(String groupId) async {
    try {
      return await _apiService.getGroupInfo(groupId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  // @override
  // Future<List<UserProfileResponseModel>> getUserInGroup(
  //   GetDataInGroupRequest request,
  // ) async {
  //   try {
  //     return await _apiService.getUserInGroup(
  //       request.groupId,
  //       request.limit,
  //       request.offset,
  //     );
  //   } catch (e) {
  //     throw ExceptionConverter.convert(e);
  //   }
  // }

  @override
  Future<void> updateGroupInfo(
    String groupId, {
    String? bio,
    String? name,
    MultipartFile? image,
  }) async {
    try {
      await _apiService.updateGroupInfo(
        groupId,
        UpdateGroupInfoRequest(bio: bio, title: name),
      );
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<UpdateGroupAvatarResponse> updateGroupAvatar(String groupId, String image) async {
    try {
      final multipartFile = await image.toMultipartFile();
      if (multipartFile == null) throw NoFileFoundException();
      return await _apiService.updateGroupAvatar(groupId, multipartFile);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> markAsRead(String groupId) async {
    try {
      return await _apiService.markAsRead(groupId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> markUnread(String groupId) async {
    try {
      return await _apiService.markAsRead(groupId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> changeNotificationStatus({
    required String groupId,
    required bool enable,
    String? option,
  }) async {
    try {
      return await _apiService.changeNotificationStatus(
        groupId,
        ChangeNotificationStatusRequest(enabled: enable, dndDuration: option),
      );
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> leaveGroup(String groupId, String userId) async {
    try {
      return await _apiService.leaveGroup(groupId, userId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
