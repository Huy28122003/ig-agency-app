import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_message_request_model.g.dart';

@JsonSerializable()
class SendMessageRequestModel {
  final String type;
  final String text;
  final String? replyToMessageId;

  SendMessageRequestModel({
    required this.type,
    required this.text,
    this.replyToMessageId,
  });

  Map<String, dynamic> toJson() => _$SendMessageRequestModelToJson(this);
}
