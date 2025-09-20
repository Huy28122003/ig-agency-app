import 'dart:async';
import '../entities/user/profile_info_entity.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<ProfileInfoEntity> getProfileInfo([bool isForceFetch = false]);

  Stream<ProfileInfoEntity> get fetchProfileInfo;

  Future updateProfileInfo(ProfileInfoEntity user);

  Future updateUsername(String name);

  Future updateProfileBio(String bio);

  Future<UserEntity> getUserInfo(String userId);
}
