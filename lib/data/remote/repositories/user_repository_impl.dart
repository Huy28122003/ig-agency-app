import 'dart:async';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../shared/commons/failure_converter.dart';
import '../../cache/ram_cache.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._ramCache);

  final RamCache _ramCache;

  @override
  Stream<UserEntity> get userStream => _ramCache.getProfileInfoStream();

  @override
  Future<UserEntity> fetchCurrentUser() async {
    try {
      final user = _ramCache.getLatestProfileInfo();
      if (user == null) {
        throw Exception('User not found');
      }
      return user;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future updateUser(UserEntity user) async {
    try {
      _ramCache.saveProfileInfo(user);
      return;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future updateUserName(String name) async {
    try {
      // TODO hoannk: Call API update user name

      final user = _ramCache.getLatestProfileInfo();
      if (user == null) {
        throw Exception('User not found');
      }
      final newUser = user.copyWith(name: name);
      _ramCache.saveProfileInfo(newUser);
      return;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future updateUserBio(String bio) async {
    try {
      // TODO hoannk: Call API update user bio
      final user = _ramCache.getLatestProfileInfo();
      if (user == null) {
        throw Exception('User not found');
      }
      final newUser = user.copyWith(bio: bio);
      _ramCache.saveProfileInfo(newUser);
      return;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
