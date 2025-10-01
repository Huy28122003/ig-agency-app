import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class ChangePasswordUseCase extends UseCase<void, ChangePasswordParam> {
  ChangePasswordUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future call(ChangePasswordParam param) async {
    return await _authRepository.changePassword(
      param.currentPassword,
      param.newPassword,
      param.passwordConfirm,
    );
  }
}

class ChangePasswordParam {
  ChangePasswordParam({
    required this.currentPassword,
    required this.newPassword,
    required this.passwordConfirm,
  });

  final String currentPassword;
  final String newPassword;
  final String passwordConfirm;
}
