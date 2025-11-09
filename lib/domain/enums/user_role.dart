enum UserRole {
  admin,
  user;

  static UserRole fromString(String role) {
    if (role.toLowerCase() == role.toLowerCase()) {
      return admin;
    } else {
      return user;
    }
  }

  bool get isAdmin => this == admin;
}
