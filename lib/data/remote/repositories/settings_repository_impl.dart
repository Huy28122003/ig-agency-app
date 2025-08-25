import 'package:ig_agency_app/domain/repositories/settings_repository.dart';
import 'package:ig_agency_app/shared/commons/failure_converter.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/commons/result.dart';
import '../../local/app/settings_local_data_source.dart';

@Injectable(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _settingsLocalDataSource;

  SettingsRepositoryImpl(this._settingsLocalDataSource);

  @override
  Future<Result<bool>> getDarkMode() async {
    try {
      final isDarkMode = await _settingsLocalDataSource.getDarkMode();
      return Result.completed(isDarkMode);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }

  @override
  Future<Result<void>> setDarkMode(bool isDarkMode) async {
    try {
      await _settingsLocalDataSource.setDarkMode(isDarkMode);
      return Result.completed(null);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }

  @override
  Future<Result<bool>> getInAppAlerts() async {
    try {
      final isInAppAlerts = await _settingsLocalDataSource.getInAppAlerts();
      return Result.completed(isInAppAlerts);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }

  @override
  Future<Result<void>> setInAppAlerts(bool isInAppAlerts) async {
    try {
      await _settingsLocalDataSource.setInAppAlerts(isInAppAlerts);
      return Result.completed(null);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }
}
