class ValidatorUtil {
  static bool isValidEmail(String rawEmail) {
    final email = rawEmail.trim();
    return RegExp(
      r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$",
    ).hasMatch(email);
  }
}
