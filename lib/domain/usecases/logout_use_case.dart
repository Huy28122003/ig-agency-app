import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/result.dart';
import '../repositories/auth_repository.dart';

@injectable
class LogoutUseCase extends UseCase<void, void> {
  LogoutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<void>> call(void param) async {
    return await _authRepository.logout();
  }
}
