import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_entity.freezed.dart';

part 'forgot_password_entity.g.dart';

@freezed
abstract class ForgotPasswordEntity with _$ForgotPasswordEntity {
  const factory ForgotPasswordEntity({
    required String id,
    @Default('') String email,
    @Default('') String otp,
    @Default(false) isUsed,
    DateTime? expiresAt,
  }) = _ForgotPasswordEntity;

  factory ForgotPasswordEntity.fromJson(Map<String, Object?> json) =>
      _$ForgotPasswordEntityFromJson(json);
}
