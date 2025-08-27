import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/result.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

@injectable
class FetchCurrentUserUseCase extends UseCase<UserEntity, void> {
  FetchCurrentUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Result<UserEntity>> call(void param) async {
    return await _userRepository.fetchCurrentUser();
  }
}
