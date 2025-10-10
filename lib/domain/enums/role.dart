enum RoleSystem {
  admin("admin"),
  user("user"),
  telegramUser("telegram_user"),
  guest("guest");

  final String code;

  const RoleSystem(this.code);

  static RoleSystem fromString(String role) {
    switch (role) {
      case 'admin':
        return RoleSystem.admin;
      case 'user':
        return RoleSystem.user;
      case 'telegram_user':
        return RoleSystem.telegramUser;
      default:
        return RoleSystem.guest;
    }
  }
}

extension RoleSystemExtension on RoleSystem {
  bool get isAdmin => this == RoleSystem.admin;

  bool get isUser => this == RoleSystem.user;

  bool get isGuest => this == RoleSystem.guest;

  bool get isTelegramUset => this == RoleSystem.telegramUser;
}
