import 'package:ig_agency_app/data/remote/models/response/last_message_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_workspaces_response_model.g.dart';

@JsonSerializable()
class GroupResponse {
  const GroupResponse({
    required this.id,
    required this.title,
    this.lastMessageDate,
    required this.pinned,
    required this.status,
    required this.type,
    this.lastMessage,
  });

  final String id;
  final String type;
  final String title;
  final int? lastMessageDate;
  final bool pinned;
  final String status;
  final LastMessageResponseModel? lastMessage;

  factory GroupResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GroupResponseToJson(this);
}
