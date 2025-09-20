import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../entities/user/profile_info_entity.dart';
import '../repositories/user_repository.dart';

@injectable
class GetProfileInfoUseCase extends UseCase<ProfileInfoEntity, bool> {
  GetProfileInfoUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<ProfileInfoEntity> call([bool isForceFetch = false]) async {
    return _userRepository.getProfileInfo(isForceFetch);
  }
}
