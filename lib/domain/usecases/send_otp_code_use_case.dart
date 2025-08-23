import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:ig_agency_app/shared/commons/result.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/failure.dart';
import '../../shared/commons/failure_converter.dart';
import '../repositories/auth_repository.dart';

@injectable
class SendOtpCodeUseCase extends UseCase<void, String> {
  SendOtpCodeUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<void>> call(String email) async {
    try {
      await _authRepository.sendOtpCode(email);
      return Result.completed(null);
    } catch (e) {
      final failure = e is Failure ? e : FailureConverter.convert(e);
      return Result.failure(failure);
    }
  }
}
