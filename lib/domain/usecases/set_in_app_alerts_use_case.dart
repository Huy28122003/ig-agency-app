import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/result.dart';
import '../repositories/settings_repository.dart';

@injectable
class SetInAppAlertsUseCase extends UseCase<void, SetInAppAlertsParam> {
  SetInAppAlertsUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<Result<void>> call(SetInAppAlertsParam param) async {
    return await _settingsRepository.setInAppAlerts(param.isInAppAlerts);
  }
}

class SetInAppAlertsParam {
  SetInAppAlertsParam({required this.isInAppAlerts});

  final bool isInAppAlerts;
}
