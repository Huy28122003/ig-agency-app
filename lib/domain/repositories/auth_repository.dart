abstract class AuthRepository {
  Future login(String email, String password);

  Future register(String name, String email, String password);

  Future logout();

  Future<String> getAccessToken();

  Future saveAccessToken(String token);

  Future clearAccessToken();

  Future sendOtpCode(String email);

  Future verifyOtpCode(String code);

  Future sendNewPassword(String email, String newPassword);

  Future changePassword(
    String currentPassword,
    String newPassword,
    String passwordConfirm,
  );

  Future deleteAccount(String userId);

  Future<String?> getEmail();

  Future saveEmail(String email);
}
