import 'package:ig_agency_app/domain/repositories/user_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateAvatarUseCase extends UseCase<void, UpdateAvatarParam> {
  UpdateAvatarUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future call(UpdateAvatarParam param) async {
    return await _userRepository.updateUserAvatar(param.avatarPath);
  }
}

class UpdateAvatarParam {
  UpdateAvatarParam({required this.avatarPath});

  final String avatarPath;
}
