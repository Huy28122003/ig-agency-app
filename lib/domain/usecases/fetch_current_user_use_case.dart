import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

@injectable
class FetchCurrentUserUseCase extends UseCase<UserEntity, NoParam> {
  FetchCurrentUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<UserEntity> call(NoParam param) async {
    return _userRepository.fetchCurrentUser();
  }
}
