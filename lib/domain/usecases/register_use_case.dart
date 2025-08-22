import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:ig_agency_app/shared/commons/result.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/failure.dart';
import '../../shared/commons/failure_converter.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase extends UseCase<void, RegisterParam> {
  RegisterUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<void>> call(RegisterParam param) async {
    try {
      await _authRepository.register(
        param.name,
        param.email,
        param.password,
        param.confirmPassword,
      );
      return Result.completed(null);
    } catch (e) {
      final failure = e is Failure ? e : FailureConverter.convert(e);
      return Result.failure(failure);
    }
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
