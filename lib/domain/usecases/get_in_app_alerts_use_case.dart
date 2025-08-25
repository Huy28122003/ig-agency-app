import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/result.dart';
import '../repositories/settings_repository.dart';

@injectable
class GetInAppAlertsUseCase extends UseCase<bool, void> {
  GetInAppAlertsUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<Result<bool>> call(void param) async {
    return await _settingsRepository.getInAppAlerts();
  }
}
