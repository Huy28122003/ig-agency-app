import 'package:ig_agency_app/data/remote/models/response/forgot_password_response_model.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@injectable
class SendOtpCodeUseCase extends UseCase<ForgotPasswordResponseModel, String> {
  SendOtpCodeUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<ForgotPasswordResponseModel> call(String email) async {
    return await _authRepository.sendOtpCode(email);
  }
}
