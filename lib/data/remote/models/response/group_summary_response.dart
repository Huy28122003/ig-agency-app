import 'package:json_annotation/json_annotation.dart';
import 'last_message_response_model.dart';

part 'group_summary_response.g.dart';

@JsonSerializable()
class GroupSummaryResponse {
  const GroupSummaryResponse({
    required this.id,
    this.title = '',
    this.photo,
    this.lastMessage,
    this.lastMessageDate,
    this.pinned = false,
    this.status = '',
    this.isRead = false,
    this.notificationEnabled = true,
    this.unreadCount = 0,
  });

  final String id;
  final String title;
  // final GroupAvatarResponse? photo;
  final String? photo;
  final int? lastMessageDate;
  final bool pinned;
  final String status;
  final LastMessageResponseModel? lastMessage;
  final bool isRead;
  final bool notificationEnabled;
  final int unreadCount;

  factory GroupSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupSummaryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GroupSummaryResponseToJson(this);
}
