abstract class SettingsLocalDataSource {
  Future<bool> getDarkMode();

  Future<void> setDarkMode(bool isDarkMode);

  Future<bool> getInAppAlerts();

  Future<void> setInAppAlerts(bool isInAppAlerts);
}
