import 'package:ig_agency_app/data/remote/models/requests/forgot_password_request_model.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class SendNewPasswordUseCase extends UseCase<bool, ForgotPasswordRequestModel> {
  SendNewPasswordUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<bool> call(ForgotPasswordRequestModel request) async {
    return await _authRepository.sendNewPassword(request);
  }
}
