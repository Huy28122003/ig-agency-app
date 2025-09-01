import 'package:ig_agency_app/domain/repositories/auth_repository.dart';
import 'package:ig_agency_app/shared/commons/failure_converter.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../shared/commons/result.dart';
import '../../cache/ram_cache.dart';
import '../app/auth_remote_data_source.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final RamCache _ramCache;

  AuthRepositoryImpl(this._authRemoteDataSource, this._ramCache);

  @override
  Future<void> clearToken() {
    try {
      // Simulate clearing token
      return Future.value();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<String?> getToken() {
    try {
      // Simulate fetching token
      return _authRemoteDataSource.getAccessToken();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<Result> login(String email, String password) async {
    try {
      // Simulate login process
      await _authRemoteDataSource.login(email, password);
      _ramCache.saveProfileInfo(
        UserEntity(
          id: '1',
          name: 'Đinh Thị Quỳnh',
          email: email,
          avatar: 'https://placehold.co/44x44',
          createdAt: DateTime.now(),
          updatedAt: null,
        ),
      );
      return Result.completed(null);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }

  @override
  Future<Result> logout() async {
    try {
      // Simulate login process
      await _authRemoteDataSource.logout();
      clearToken();
      _ramCache.clearUserData();
      return Result.completed(null);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }

  @override
  Future<void> saveToken(String token) {
    try {
      // Simulate saving token
      return Future.value();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<Result> register(String name, String email, String password) async {
    try {
      // Simulate register process
      await _authRemoteDataSource.register(name, email, password);
      _ramCache.saveProfileInfo(
        UserEntity(
          id: '1',
          name: name,
          email: email,
          avatar: 'https://placehold.co/44x44',
          createdAt: DateTime.now(),
          updatedAt: null,
        ),
      );
      return Result.completed(null);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }

  @override
  Future<Result> sendOtpCode(String email) async {
    try {
      // Simulate register process
      await _authRemoteDataSource.sendOtpCode(email);
      return Result.completed(null);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }

  @override
  Future<Result<bool>> verifyOtpCode(String code) async {
    try {
      // Simulate register process
      final result = await _authRemoteDataSource.verifyOtpCode(code);
      return Result.completed(result);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }

  @override
  Future<bool> sendNewPassword(String email, String newPassword) {
    try {
      // Simulate register process
      return _authRemoteDataSource.sendNewPassword(email, newPassword);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<Result> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      // Simulate change password process
      await _authRemoteDataSource.changePassword(currentPassword, newPassword);
      return Result.completed(null);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }

  @override
  Future<Result> deleteAccount(String userId) async {
    try {
      await _authRemoteDataSource.deleteAccount(userId);
      clearToken();
      return Result.completed(null);
    } catch (e) {
      return Result.failure(FailureConverter.convert(e));
    }
  }
}
