abstract class AuthRemoteDataSource {
  Future<void> login(String email, String password);

  Future<void> register(String name, String email, String password);

  Future<void> logout();

  Future<void> refreshToken();

  Future<void> revokeTokens();

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<String> sendOtpCode(String email);

  Future<bool> sendNewPassword(String email, String newPassword);
}
