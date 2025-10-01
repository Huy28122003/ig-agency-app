import 'package:ig_agency_app/data/local/app/auth_local_data_source.dart';
import 'package:ig_agency_app/data/local/app/user_local_data_source.dart';
import 'package:ig_agency_app/data/remote/models/requests/forgot_password_request_model.dart';
import 'package:ig_agency_app/data/remote/models/requests/login_request_model.dart';
import 'package:ig_agency_app/data/remote/models/requests/logout_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/forgot_password_response_model.dart';
import 'package:ig_agency_app/data/remote/translators/profile_info_translator.dart';
import 'package:ig_agency_app/domain/repositories/auth_repository.dart';
import 'package:ig_agency_app/shared/commons/failure_converter.dart';
import 'package:ig_agency_app/shared/utils/device_manager.dart';
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
      final deviceType = DeviceManager.getDeviceType();
      final deviceId = await DeviceManager.getOrCreateDeviceId();
      final osVersion = await DeviceManager.getOsVersion() ?? "";
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
      final profile = await _userLocalDataSource.getProfileInfo();

      final request = LogoutRequestModel(
        userId: profile?.id ?? '',
        deviceId: await DeviceManager.getOrCreateDeviceId(),
        deviceType: DeviceManager.getDeviceType(),
      );

      // Simulate login process
      _ramCache.clearUserData();
      await _remoteDataSource.logout(request);
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
      await _remoteDataSource.register(name, email, password);
      return;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<ForgotPasswordResponseModel> sendOtpCode(String email) async {
    try {
      return await _remoteDataSource.sendOtpCode(email);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future sendNewPassword(ForgotPasswordRequestModel request) async {
    try {
      return await _remoteDataSource.sendNewPassword(request);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future changePassword(String currentPassword, String newPassword) async {
    try {
      return await _remoteDataSource.changePassword(
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
