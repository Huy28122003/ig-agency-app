class ChangePasswordRequestModel {
  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  ChangePasswordRequestModel({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });
  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'password': password,
      'passwordConfirmation': passwordConfirmation,
    };
  }
}
