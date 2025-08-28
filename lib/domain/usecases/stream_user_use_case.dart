import 'dart:async';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/repositories/user_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class StreamUserUseCase extends StreamUseCase<UserEntity, NoParam> {
  StreamUserUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Stream<UserEntity> call(NoParam param) {
    return _userRepository.userStream;
  }
}
