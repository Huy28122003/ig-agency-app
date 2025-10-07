import 'package:ig_agency_app/data/remote/models/requests/forgot_password_request_model.dart';

import '../entities/forgot_password_entity.dart';

abstract class AuthRepository {
  Future login(String email, String password);

  Future register(String name, String email, String password);

  Future logout();

  Future<String> getAccessToken();

  Future saveAccessToken(String token);

  Future clearAccessToken();

  Future<ForgotPasswordEntity> sendOtpCode(String email);

  Future<ForgotPasswordEntity> verifyOtpCode(String email, String otp);

  Future sendNewPassword(ForgotPasswordRequestModel request);

  Future changePassword(String currentPassword, String newPassword);

  Future deleteAccount();

  Future<String?> getEmail();

  Future saveEmail(String email);
}
