import 'package:ig_agency_app/domain/repositories/auth_repository.dart';
import 'package:ig_agency_app/shared/commons/failure_converter.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../cache/ram_cache.dart';
import '../app/auth_remote_data_source.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final RamCache _ramCache;

  AuthRepositoryImpl(this._authRemoteDataSource, this._ramCache);

  @override
  Future clearToken() async {
    try {
      // Simulate clearing token
      return;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future getToken() async {
    try {
      // Simulate fetching token
      return await _authRemoteDataSource.getAccessToken();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future login(String email, String password) async {
    try {
      // Simulate login process
      await _authRemoteDataSource.login(email, password);
      return _ramCache.saveProfileInfo(
        UserEntity(
          id: '1',
          name: 'Đinh Thị Quỳnh',
          email: email,
          avatar: 'https://placehold.co/44x44',
          createdAt: DateTime.now(),
          updatedAt: null,
          isAdmin: false,
          lastActiveAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future logout() async {
    try {
      // Simulate login process
      await _authRemoteDataSource.logout();
      _ramCache.clearUserData();
      return await clearToken();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future saveToken(String token) async {
    try {
      // Simulate saving token
      return Future.value();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future register(String name, String email, String password) async {
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
          lastActiveAt: DateTime.now().subtract(const Duration(hours: 5)),
          isAdmin: false,
        ),
      );
      return;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future sendOtpCode(String email) async {
    try {
      // Simulate register process
      return await _authRemoteDataSource.sendOtpCode(email);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<bool> verifyOtpCode(String code) async {
    try {
      return await _authRemoteDataSource.verifyOtpCode(code);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future sendNewPassword(String email, String newPassword) async {
    try {
      return await _authRemoteDataSource.sendNewPassword(email, newPassword);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future changePassword(String currentPassword, String newPassword) async {
    try {
      return await _authRemoteDataSource.changePassword(
        currentPassword,
        newPassword,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future deleteAccount(String userId) async {
    try {
      await _authRemoteDataSource.deleteAccount(userId);
      return await clearToken();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
