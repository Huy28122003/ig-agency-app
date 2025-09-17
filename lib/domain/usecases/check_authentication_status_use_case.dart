import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class CheckAuthenticationStatusUseCase extends UseCase<bool, NoParam> {
  CheckAuthenticationStatusUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<bool> call([NoParam? param]) async {
    final accessToken = await _authRepository.getAccessToken();
    return accessToken.isNotEmpty;
  }
}
