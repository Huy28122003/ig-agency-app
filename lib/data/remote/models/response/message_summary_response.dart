import 'package:json_annotation/json_annotation.dart';

part 'message_summary_response.g.dart';

@JsonSerializable()
class MessageSummaryResponse {
  const MessageSummaryResponse({
    required this.id,
    required this.message,
    required this.userAvatar,
  });

  final int id;
  final String message;
  final String userAvatar;

  factory MessageSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageSummaryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MessageSummaryResponseToJson(this);
}
