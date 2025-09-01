import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyOtpUseCase extends UseCase<bool, String> {
  VerifyOtpUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<bool> call(String param) async {
    return await _authRepository.verifyOtpCode(param);
  }
}
