import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase extends UseCase<void, LoginParam> {
  LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future call(LoginParam param) async {
    try{

       await _authRepository.login(param.email, param.password);
    } catch(e){
      print(e);
    }
  }
}

class LoginParam {
  LoginParam({required this.email, required this.password});

  final String email;
  final String password;
}
