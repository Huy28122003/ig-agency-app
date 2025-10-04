import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';
import '../entities/forgot_password_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class SendOtpCodeUseCase extends UseCase<ForgotPasswordEntity, String> {
  SendOtpCodeUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<ForgotPasswordEntity> call(String email) async {
    return await _authRepository.sendOtpCode(email);
  }
}
