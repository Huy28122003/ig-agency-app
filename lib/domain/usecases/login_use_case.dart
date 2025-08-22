import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/failure.dart';
import '../../shared/commons/failure_converter.dart';
import '../../shared/commons/result.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase extends UseCase<void, LoginParam> {
  LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<void>> call(LoginParam param) async {
    try {
      await _authRepository.login(param.email, param.password);
      return Result.completed(null);
    } catch (e) {
      final failure = e is Failure ? e : FailureConverter.convert(e);
      return Result.failure(failure);
    }
  }
}

class LoginParam {
  LoginParam({required this.email, required this.password});

  final String email;
  final String password;
}
