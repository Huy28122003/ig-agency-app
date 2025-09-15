import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.g.dart';

@JsonSerializable()
class LoginRequestModel {
  final String email;
  final String password;
  final String deviceType;
  final String deviceId;
  final String? deviceToken;
  final String? model;
  final String osVersion;

  LoginRequestModel({
    required this.email,
    required this.password,
    required this.deviceType,
    required this.deviceId,
    this.deviceToken,
    this.model,
    required this.osVersion,
  });

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}
