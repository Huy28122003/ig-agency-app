import '../../shared/commons/result.dart';

abstract class AuthRepository {
  Future<Result> login(String email, String password);

  Future<Result> register(String name, String email, String password);

  Future<void> logout();

  Future<String?> getToken();

  Future<void> saveToken(String token);

  Future<void> clearToken();

  Future<String> sendOtpCode(String email);
}
