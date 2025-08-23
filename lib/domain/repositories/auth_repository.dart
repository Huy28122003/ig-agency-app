abstract class AuthRepository {
  Future login(String email, String password);

  Future register(
    String name,
    String email,
    String password,
    String confirmPassword,
  );

  Future<void> logout();

  Future<String?> getToken();

  Future<void> saveToken(String token);

  Future<void> clearToken();

  Future<String> sendOtpCode(String email);
}
