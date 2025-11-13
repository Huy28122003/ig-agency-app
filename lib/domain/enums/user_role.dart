enum UserRole {
  admin,
  user;

  static UserRole fromString(String? role) {
    if (role == 'admin') {
      return admin;
    } else {
      return user;
    }
  }

  bool get isAdmin => this == admin;
}
