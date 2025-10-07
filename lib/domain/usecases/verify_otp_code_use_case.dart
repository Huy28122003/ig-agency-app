import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:ig_agency_app/shared/commons/validation_failure.dart';
import 'package:injectable/injectable.dart';
import '../entities/forgot_password_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyOtpCodeUseCase
    extends UseCase<ForgotPasswordEntity, VerifyOtpParam> {
  VerifyOtpCodeUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<ForgotPasswordEntity> call(VerifyOtpParam param) async {
    final result = await _authRepository.verifyOtpCode(param.email, param.otp);
    if (result.expiresAt?.isBefore(DateTime.now()) == true) {
      throw OtpExpiredFailure();
    }
    return result;
  }
}

class VerifyOtpParam {
  final String otp;
  final String email;

  VerifyOtpParam(this.otp, this.email);
}
