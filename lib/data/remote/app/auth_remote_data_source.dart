import 'package:ig_agency_app/data/remote/models/requests/forgot_password_request_model.dart';
import 'package:ig_agency_app/data/remote/models/requests/login_request_model.dart';
import 'package:ig_agency_app/data/remote/models/requests/logout_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/forgot_password_response_model.dart';
import 'package:ig_agency_app/data/remote/models/response/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);

  Future<void> register(String name, String email, String password);

  Future<void> logout(LogoutRequestModel request);

  Future<void> refreshToken();

  Future<void> revokeTokens();

  Future<ForgotPasswordResponseModel> sendOtpCode(String email);

  Future<void> sendNewPassword(ForgotPasswordRequestModel request);

  Future<void> changePassword(String currentPassword, String newPassword);

  Future<void> deleteAccount(String userId);
}
