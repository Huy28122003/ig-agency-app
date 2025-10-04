import 'package:ig_agency_app/data/remote/models/response/forgot_password_response_model.dart';
import 'package:ig_agency_app/domain/entities/forgot_password_entity.dart';
import 'package:ig_agency_app/shared/extensions/date_time_extension.dart';

extension ForgotPasswordTranslator on ForgotPasswordResponseModel {
  ForgotPasswordEntity toEntity() {
    return ForgotPasswordEntity(
      id: id ?? '',
      email: email ?? '',
      otp: otp ?? '',
      isUsed: used,
      expiresAt: expiresAt?.toDate()?.toLocal(),
    );
  }
}
