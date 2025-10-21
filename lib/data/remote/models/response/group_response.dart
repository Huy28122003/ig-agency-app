import 'package:json_annotation/json_annotation.dart';

import 'group_avatar_response.dart';

part 'group_response.g.dart';

@JsonSerializable()
class GroupResponse {
  const GroupResponse({
    required this.id,
    this.title = '',
    this.lastMessageDate,
    // this.pinned = false,
    // this.status = '',
    // this.type = '',
    // this.lastMessage,
    this.pinnedMessageCount = 0,
    this.memberCount = 0,
    this.onlineMemberCount = 0,
    this.photo,
  });

  final String id;

  // final String type;
  final String title;
  final int? lastMessageDate;

  // final bool pinned;
  // final String status;
  final int pinnedMessageCount;
  final int memberCount;
  final int onlineMemberCount;

  // final LastMessageResponseModel? lastMessage;
  final GroupAvatarResponse? photo;

  factory GroupResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GroupResponseToJson(this);
}
