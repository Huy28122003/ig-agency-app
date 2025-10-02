import 'package:ig_agency_app/data/remote/models/requests/forgot_password_request_model.dart';
import 'package:ig_agency_app/data/remote/models/requests/logout_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/forgot_password_response_model.dart';
import 'package:ig_agency_app/data/remote/models/response/login_response_model.dart';
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
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      return await _apiService.login(request);
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
      await _apiService.register(registerRequestModel);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> logout(LogoutRequestModel request) async {
    try {
      await _apiService.logout(request);
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
  Future<ForgotPasswordResponseModel> sendOtpCode(
    String email, [
    String? otp,
  ]) async {
    try {
      final request = ForgotPasswordRequestModel(email: email, otp: otp);
      return await _apiService.forgotPassword(request);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> sendNewPassword(ForgotPasswordRequestModel request) async {
    try {
      await _apiService.resetPassword(request);
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
