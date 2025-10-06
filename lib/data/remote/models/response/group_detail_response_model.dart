import 'package:json_annotation/json_annotation.dart';
import 'package:ig_agency_app/data/remote/models/response/message_response_model.dart';

part 'group_detail_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupDetailResponseModel {
  const GroupDetailResponseModel({
    required this.id,
    required this.type,
    required this.title,
    this.lastMessage,
    required this.lastMessageDate,
    required this.pinned,
    required this.status,
    this.recentPinnedMessage,
    required this.pinnedMessageCount,
    required this.memberCount,
    required this.onlineMemberCount,
  });

  factory GroupDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GroupDetailResponseModelFromJson(json);

  final String id;
  final String type;
  final String title;
  final MessageResponseModel? lastMessage;
  final int lastMessageDate;
  final bool pinned;
  final String status;
  final MessageResponseModel? recentPinnedMessage;
  final int pinnedMessageCount;
  final int memberCount;
  final int onlineMemberCount;

  Map<String, dynamic> toJson() => _$GroupDetailResponseModelToJson(this);
}
