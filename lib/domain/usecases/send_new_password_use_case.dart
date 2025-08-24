import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:ig_agency_app/shared/commons/result.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/failure.dart';
import '../../shared/commons/failure_converter.dart';
import '../repositories/auth_repository.dart';

@injectable
class SendNewPasswordUseCase extends UseCase<bool, SendNewPasswordParams> {
  SendNewPasswordUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<bool>> call(SendNewPasswordParams params) async {
    try {
      final result = await _authRepository.sendNewPassword(
        params.email,
        params.newPassword,
      );
      return Result.completed(result);
    } catch (e) {
      final failure = e is Failure ? e : FailureConverter.convert(e);
      return Result.failure(failure);
    }
  }
}

class SendNewPasswordParams {
  SendNewPasswordParams({required this.email, required this.newPassword});

  final String email;
  final String newPassword;
}
