import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_response_model.g.dart';

@JsonSerializable()
class ForgotPasswordResponseModel {
  const ForgotPasswordResponseModel({
    this.id,
    this.email,
    this.otp,
    this.used = false,
    this.expiresAt,
  });

  final String? id;
  final String? email;
  final String? otp;
  final bool used;
  final String? expiresAt;

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordResponseModelToJson(this);
}
