import 'package:json_annotation/json_annotation.dart';
import 'group_avatar_response.dart';
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
    this.isSeen = false,
    this.isMute = true,
  });

  final String id;
  final String title;
  final GroupAvatarResponse? photo;
  final int? lastMessageDate;
  final bool pinned;
  final String status;
  final LastMessageResponseModel? lastMessage;
  final bool isSeen;
  final bool isMute;

  factory GroupSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupSummaryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GroupSummaryResponseToJson(this);
}
