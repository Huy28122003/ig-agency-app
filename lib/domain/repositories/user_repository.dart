import 'dart:async';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> fetchCurrentUser();

  Stream<UserEntity> get userStream;

  Future updateUser(UserEntity user);

  Future updateUserName(String name);

  Future updateUserBio(String bio);
}
