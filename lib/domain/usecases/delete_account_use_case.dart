import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class DeleteAccountUseCase extends UseCase<void, NoParam> {
  DeleteAccountUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future call(NoParam param) async {
    return await _authRepository.deleteAccount();
  }
}
