import 'package:ig_agency_app/dependencies/local_storage/local_storage_manager.dart';
import 'package:injectable/injectable.dart';

import '../app/settings_local_data_source.dart';

@Injectable(as: SettingsLocalDataSource)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl(this._localStorageManager);

  final LocalStorageManager _localStorageManager;

  @override
  Future<bool> getDarkMode() async {
    return await _localStorageManager.getValue<bool>(
          LocalStorageKeys.isDarkMode,
        ) ??
        false;
  }

  @override
  Future<void> setDarkMode(bool isDarkMode) {
    return _localStorageManager.setValue<bool>(
      LocalStorageKeys.isDarkMode,
      isDarkMode,
    );
  }

  @override
  Future<bool> getInAppAlerts() async {
    return await _localStorageManager.getValue<bool>(
          LocalStorageKeys.isInAppAlerts,
        ) ??
        true;
  }

  @override
  Future<void> setInAppAlerts(bool isInAppAlerts) async {
    return _localStorageManager.setValue<bool>(
      LocalStorageKeys.isInAppAlerts,
      isInAppAlerts,
    );
  }
}
