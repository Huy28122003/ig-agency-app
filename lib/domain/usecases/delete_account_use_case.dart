import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/result.dart';
import '../repositories/auth_repository.dart';

@injectable
class DeleteAccountUseCase extends UseCase<void, DeleteAccountParam> {
  DeleteAccountUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<void>> call(DeleteAccountParam param) async {
    return await _authRepository.deleteAccount(param.userId);
  }
}

class DeleteAccountParam {
  DeleteAccountParam({required this.userId});

  final String userId;
}
