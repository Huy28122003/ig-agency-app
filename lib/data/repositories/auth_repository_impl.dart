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
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _userLocalDataSource;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._ramCache,
    this._localDataSource,
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
      final accessToken = await _localDataSource.getAccessToken();
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

      final response = await _remoteDataSource.login(request);
      final profileInfo = response.user.toEntity();
      _ramCache.saveProfileInfo(profileInfo);
      await _localDataSource.saveEmail(email);
      await _localDataSource.saveAccessToken(response.accessToken);
      await _userLocalDataSource.saveProfileInfo(profileInfo);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future logout() async {
    try {
      // Simulate login process
      _ramCache.clearUserData();
      await _remoteDataSource.logout();
      await _localDataSource.logout();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future saveAccessToken(String token) async {
    try {
      await _localDataSource.saveAccessToken(token);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future register(String name, String email, String password) async {
    try {
      // Simulate register process
      await _remoteDataSource.register(name, email, password);
      return;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future sendOtpCode(String email) async {
    try {
      // Simulate register process
      return await _remoteDataSource.sendOtpCode(email);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<bool> verifyOtpCode(String code) async {
    try {
      return await _remoteDataSource.verifyOtpCode(code);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future sendNewPassword(String email, String newPassword) async {
    try {
      return await _remoteDataSource.sendNewPassword(email, newPassword);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String passwordConfirm,
  ) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword,
        newPassword,
        passwordConfirm,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future deleteAccount(String userId) async {
    try {
      await _remoteDataSource.deleteAccount(userId);
      return await clearAccessToken();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<String?> getEmail() async {
    return await _localDataSource.getEmail();
  }

  @override
  Future saveEmail(String email) async {
    return await _localDataSource.saveEmail(email);
  }
}
