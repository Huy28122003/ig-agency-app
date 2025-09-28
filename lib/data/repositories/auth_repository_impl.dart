import 'package:ig_agency_app/data/local/app/auth_local_data_source.dart';
import 'package:ig_agency_app/data/local/app/user_local_data_source.dart';
import 'package:ig_agency_app/data/remote/models/requests/login_request_model.dart';
import 'package:ig_agency_app/data/remote/translators/profile_info_translator.dart';
import 'package:ig_agency_app/domain/repositories/auth_repository.dart';
import 'package:ig_agency_app/shared/commons/failure_converter.dart';
import 'package:injectable/injectable.dart';

import '../cache/ram_cache.dart';
import '../remote/app/auth_remote_data_source.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final RamCache _ramCache;
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteDataSource _authRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;

  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._ramCache,
    this._authLocalDataSource,
    this._userLocalDataSource,
  );

  @override
  Future clearAccessToken() async {
    try {
      // Simulate clearing token
      return;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<String> getAccessToken() async {
    try {
      final accessToken = await _authLocalDataSource.getAccessToken();
      return accessToken ?? "";
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future login(String email, String password) async {
    try {
      final deviceType = "ios";
      final deviceId = "test";
      final osVersion = "test";
      final model = "test";
      final deviceToken = "test";
      final request = LoginRequestModel(
        email: email,
        password: password,
        deviceType: deviceType,
        deviceId: deviceId,
        osVersion: osVersion,
        model: model,
        deviceToken: deviceToken,
      );

      final response = await _authRemoteDataSource.login(request);
      final profileInfo = response.user.toEntity();
      _ramCache.saveProfileInfo(profileInfo);
      await _userLocalDataSource.saveProfileInfo(profileInfo);
      await _authLocalDataSource.saveAccessToken(response.accessToken);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future logout() async {
    try {
      // Simulate login process
      _ramCache.clearUserData();
      await _authRemoteDataSource.logout();
      await _authLocalDataSource.logout();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future saveAccessToken(String token) async {
    try {
      await _authLocalDataSource.saveAccessToken(token);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future register(String name, String email, String password) async {
    try {
      // Simulate register process
      await _authRemoteDataSource.register(name, email, password);
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
      return await clearAccessToken();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
