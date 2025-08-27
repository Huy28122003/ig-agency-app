import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/result.dart';
import '../repositories/user_repository.dart';

@injectable
class UpdateUserBioUseCase extends UseCase<void, UpdateUserBioParam> {
  UpdateUserBioUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Result<void>> call(UpdateUserBioParam param) async {
    return await _userRepository.updateUserBio(param.bio);
  }
}

class UpdateUserBioParam {
  UpdateUserBioParam({required this.bio});

  final String bio;
}
