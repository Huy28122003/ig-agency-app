enum UserGroupRole {
  admin('admin'),
  member('member');


  const UserGroupRole(this.code);

  final String code;

  static UserGroupRole fromCode(String? role) {
    if (role == 'admin') {
      return admin;
    } else {
      return member;
    }
  }

  bool get isAdmin => this == admin;
}
