abstract class AuthLocalDataSource {
  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> saveAccessToken(String accessToken);

  Future<void> saveRefreshToken(String refreshToken);

  Future<void> revokeTokens();

  Future logout();
}
