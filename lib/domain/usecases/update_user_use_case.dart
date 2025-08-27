import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/repositories/user_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/result.dart';

@injectable
class UpdateUserUseCase extends UseCase<void, UpdateUserParam> {
  UpdateUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Result<void>> call(UpdateUserParam param) async {
    return await _userRepository.updateUser(param.user);
  }
}

class UpdateUserParam {
  UpdateUserParam({required this.user});

  final UserEntity user;
}
