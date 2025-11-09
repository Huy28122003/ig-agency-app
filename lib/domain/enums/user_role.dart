enum UserRole {
  admin,
  user;

  static UserRole fromString(String role) {
    if (role.toLowerCase() == 'admin'.toLowerCase()) {
      return admin;
    } else {
      return user;
    }
  }

  bool get isAdmin => this == admin;
}
