import 'package:json_annotation/json_annotation.dart';

part 'last_message_response_model.g.dart';

@JsonSerializable()
class LastMessageResponseModel {
  const LastMessageResponseModel({
    required this.id,
    required this.text,
    required this.date,
    required this.pinned,
    required this.type,
    this.from,
  });

  final String id;
  final String type;
  final String text;
  final int date;
  final bool pinned;
  final MessageSenderResponse? from;

  factory LastMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LastMessageResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LastMessageResponseModelToJson(this);
}

@JsonSerializable()
class MessageSenderResponse {
  const MessageSenderResponse({
    required this.id,
    required this.name,
    required this.role,
    required this.status,
  });

  final String id;
  final String name;
  final String role;
  final String status;

  factory MessageSenderResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageSenderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MessageSenderResponseToJson(this);
}
