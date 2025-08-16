import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:ig_agency_app/shared/commons/result.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase extends UseCase<void, LoginParam> {
  LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<void>> call(LoginParam param) async {
    final result = await _authRepository.login(param.email, param.password);
    return result;
  }
}

class LoginParam {
  LoginParam({required this.email, required this.password});

  final String email;
  final String password;
}
