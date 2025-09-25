import 'package:ig_agency_app/data/remote/models/response/last_message_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_workspaces_response_model.g.dart';

@JsonSerializable()
class GetWorkspacesResponseModel {
  const GetWorkspacesResponseModel({
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

  factory GetWorkspacesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetWorkspacesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetWorkspacesResponseModelToJson(this);
}
