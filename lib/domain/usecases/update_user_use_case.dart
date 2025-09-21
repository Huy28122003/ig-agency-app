import 'package:ig_agency_app/domain/repositories/user_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../entities/user/profile_info_entity.dart';

@injectable
class UpdateUserUseCase extends UseCase<void, UpdateUserParam> {
  UpdateUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future call(UpdateUserParam param) async {
    return await _userRepository.updateProfileInfo(param.user);
  }
}

class UpdateUserParam {
  UpdateUserParam({required this.user});

  final ProfileInfoEntity user;
}
