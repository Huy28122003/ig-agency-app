import 'package:ig_agency_app/data/remote/services/api_services.dart';
import 'package:ig_agency_app/shared/commons/exception_converter.dart';
import 'package:injectable/injectable.dart';

import '../app/auth_remote_data_source.dart';
import '../models/requests/login_request_model.dart';
import '../models/requests/registration_request_model.dart';
import '../models/requests/change_password_request_model.dart';
import '../models/requests/delete_account_request_model.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<String?> getAccessToken() {
    try {
      // Simulate fetching access token
      return Future.value("mock_access_token");
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<String?> getRefreshToken() {
    try {
      // Simulate fetching refresh token
      return Future.value("mock_refresh_token");
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      final loginRequestModel = LoginRequestModel(
        email: email,
        password: password,
      );
      await Future.delayed(Duration(seconds: 1));
      // return _apiService.login(loginRequestModel);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      final registerRequestModel = RegistrationRequestModel(
        name: name,
        email: email,
        password: password,
      );
      // return _apiService.register(registerRequestModel);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> logout() {
    try {
      // Simulate logout process
      return Future.value();
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> refreshToken() {
    try {
      // Simulate token refresh process
      return Future.value();
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> revokeTokens() {
    try {
      // Simulate revoking tokens
      return Future.value();
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> sendOtpCode(String email) {
    try {
      // Simulate revoking tokens
      return Future.value('123456');
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<bool> verifyOtpCode(String code) {
    try {
      // Simulate revoking tokens
      return Future.value(true);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<bool> sendNewPassword(String email, String newPassword) {
    try {
      // Simulate revoking tokens
      return Future.value(true);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final changePasswordRequestModel = ChangePasswordRequestModel(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      // return _apiService.changePassword(changePasswordRequestModel);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> deleteAccount(String userId) async {
    try {
      final deleteAccountRequestModel = DeleteAccountRequestModel(
        userId: userId,
      );
      // return _apiService.deleteAccount(deleteAccountRequestModel);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
