import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class SendNewPasswordUseCase extends UseCase<bool, SendNewPasswordParams> {
  SendNewPasswordUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<bool> call(SendNewPasswordParams params) async {
    return await _authRepository.sendNewPassword(
      params.email,
      params.newPassword,
    );
  }
}

class SendNewPasswordParams {
  SendNewPasswordParams({required this.email, required this.newPassword});

  final String email;
  final String newPassword;
}
