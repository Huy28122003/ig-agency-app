import 'package:ig_agency_app/data/remote/models/requests/forgot_password_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/forgot_password_response_model.dart';

abstract class AuthRepository {
  Future login(String email, String password);

  Future register(String name, String email, String password);

  Future logout();

  Future<String> getAccessToken();

  Future saveAccessToken(String token);

  Future clearAccessToken();

  Future<ForgotPasswordResponseModel> sendOtpCode(String email);

  Future sendNewPassword(ForgotPasswordRequestModel request);

  Future changePassword(String currentPassword, String newPassword);

  Future deleteAccount(String userId);

  Future<String?> getEmail();

  Future saveEmail(String email);
}
