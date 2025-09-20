import 'package:ig_agency_app/data/remote/models/requests/login_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);

  Future<void> register(String name, String email, String password);

  Future<void> logout();

  Future<void> refreshToken();

  Future<void> revokeTokens();

  Future<void> sendOtpCode(String email);

  Future<bool> verifyOtpCode(String code);

  Future<bool> sendNewPassword(String email, String newPassword);

  Future<void> changePassword(String currentPassword, String newPassword);

  Future<void> deleteAccount(String userId);
}
