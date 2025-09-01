import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase extends UseCase<void, RegisterParam> {
  RegisterUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future call(RegisterParam param) async {
    return await _authRepository.register(
      param.name,
      param.email,
      param.password,
    );
  }
}

class RegisterParam {
  RegisterParam({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String name;
  final String email;
  final String password;
  final String confirmPassword;
}
