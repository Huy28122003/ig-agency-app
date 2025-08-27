import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/result.dart';
import '../repositories/user_repository.dart';

@injectable
class UpdateUserNameUseCase extends UseCase<void, UpdateUserNameParam> {
  UpdateUserNameUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Result<void>> call(UpdateUserNameParam param) async {
    return await _userRepository.updateUserName(param.name);
  }
}

class UpdateUserNameParam {
  UpdateUserNameParam({required this.name});

  final String name;
}
