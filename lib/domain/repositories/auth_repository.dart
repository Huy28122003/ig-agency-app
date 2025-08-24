import '../../shared/commons/result.dart';

abstract class AuthRepository {
  Future<Result> login(String email, String password);

  Future<Result> register(String name, String email, String password);

  Future<void> logout();

  Future<String?> getToken();

  Future<void> saveToken(String token);

  Future<void> clearToken();

  Future<Result> sendOtpCode(String email);

  Future<Result<bool>> verifyOtpCode(String code);

  Future<bool> sendNewPassword(String email, String newPassword);
}
