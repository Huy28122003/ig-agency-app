import 'package:ig_agency_app/domain/repositories/settings_repository.dart';
import 'package:ig_agency_app/shared/commons/failure_converter.dart';
import 'package:injectable/injectable.dart';

import '../local/app/settings_local_data_source.dart';

@Injectable(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _settingsLocalDataSource;

  SettingsRepositoryImpl(this._settingsLocalDataSource);

  @override
  Future<bool> getDarkMode() async {
    try {
      return await _settingsLocalDataSource.getDarkMode();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future setDarkMode(bool isDarkMode) async {
    try {
      return await _settingsLocalDataSource.setDarkMode(isDarkMode);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<bool> getInAppAlerts() async {
    try {
      return await _settingsLocalDataSource.getInAppAlerts();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future setInAppAlerts(bool isInAppAlerts) async {
    try {
      return await _settingsLocalDataSource.setInAppAlerts(isInAppAlerts);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
