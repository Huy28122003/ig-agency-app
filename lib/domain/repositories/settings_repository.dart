import '../../shared/commons/result.dart';

abstract class SettingsRepository {
  Future<Result<bool>> getDarkMode();

  Future<Result> setDarkMode(bool isDarkMode);

  Future<Result<bool>> getInAppAlerts();

  Future<Result> setInAppAlerts(bool isInAppAlerts);
}
