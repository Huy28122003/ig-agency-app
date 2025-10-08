import 'package:json_annotation/json_annotation.dart';

part 'pin_message_request_model.g.dart';

@JsonSerializable()
class PinMessageRequestModel {
  final String messageId;

  PinMessageRequestModel({required this.messageId});

  Map<String, dynamic> toJson() => _$PinMessageRequestModelToJson(this);
}
