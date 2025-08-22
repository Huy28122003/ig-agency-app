abstract class AuthRepository {
  Future<void> login(String email, String password);

  Future<void> logout();

  Future<String?> getToken();

  Future<void> saveToken(String token);

  Future<void> clearToken();
}
