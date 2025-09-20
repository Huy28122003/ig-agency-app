import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_message_request_model.g.dart';

@JsonSerializable()
class PinMessageRequestModel {
  final String messageId;

  PinMessageRequestModel({required this.messageId});
}
