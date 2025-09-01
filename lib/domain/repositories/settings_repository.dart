abstract class SettingsRepository {
  Future<bool> getDarkMode();

  Future setDarkMode(bool isDarkMode);

  Future<bool> getInAppAlerts();

  Future setInAppAlerts(bool isInAppAlerts);
}
