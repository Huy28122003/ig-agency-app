import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../repositories/settings_repository.dart';

@injectable
class SetDarkModeUseCase extends UseCase<void, SetDarkModeParam> {
  SetDarkModeUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future call(SetDarkModeParam param) async {
    return await _settingsRepository.setDarkMode(param.isDarkMode);
  }
}

class SetDarkModeParam {
  SetDarkModeParam({required this.isDarkMode});

  final bool isDarkMode;
}
