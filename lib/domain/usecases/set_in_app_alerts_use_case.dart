import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../repositories/settings_repository.dart';

@injectable
class SetInAppAlertsUseCase extends UseCase<void, SetInAppAlertsParam> {
  SetInAppAlertsUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future call(SetInAppAlertsParam param) async {
    return await _settingsRepository.setInAppAlerts(param.enableNotification);
  }
}

class SetInAppAlertsParam {
  SetInAppAlertsParam({required this.enableNotification});

  final bool enableNotification;
}
