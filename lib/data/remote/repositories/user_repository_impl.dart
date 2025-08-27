import 'dart:async';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../shared/commons/failure_converter.dart';
import '../../../shared/commons/result.dart';
import '../../cache/ram_cache.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._ramCache);

  final RamCache _ramCache;

  @override
  Stream<UserEntity> get userStream => _ramCache.getProfileInfoStream();

  @override
  Future<Result<UserEntity>> fetchCurrentUser() async {
    try {
      final user = _ramCache.getLatestProfileInfo();
      if (user != null) {
        return Result.completed(user);
      } else {
        return Result.failure(
          FailureConverter.convert(Exception('User not found')),
        );
      }
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }

  @override
  Future<Result> updateUser(UserEntity user) async {
    try {
      _ramCache.saveProfileInfo(user);
      return Result.completed(null);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }
}
