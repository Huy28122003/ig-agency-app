import 'dart:async';
import '../../shared/commons/result.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Result<UserEntity>> fetchCurrentUser();

  Stream<UserEntity> get userStream;

  Future<Result> updateUser(UserEntity user);
}
