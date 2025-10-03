import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_request_model.g.dart';

@JsonSerializable()
class ForgotPasswordRequestModel {
  final String? email;
  final String? otp;
  final String? password;

  ForgotPasswordRequestModel({this.email, this.otp, this.password});

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestModelToJson(this);
}
