import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_request_model.g.dart';

@JsonSerializable()
class LogoutRequestModel {
  final String userId;
  final String deviceType;
  final String deviceId;

  LogoutRequestModel({required this.userId, required this.deviceType, required this.deviceId});

  Map<String, dynamic> toJson() => _$LogoutRequestModelToJson(this);
}
