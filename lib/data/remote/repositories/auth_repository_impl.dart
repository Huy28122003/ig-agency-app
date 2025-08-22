import 'package:ig_agency_app/domain/repositories/auth_repository.dart';
import 'package:ig_agency_app/shared/commons/failure_converter.dart';
import 'package:injectable/injectable.dart';

import '../app/auth_remote_data_source.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource);

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
  Future login(String email, String password) {
    try {
      // Simulate login process
      return _authRemoteDataSource.login(email, password);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> logout() {
    try {
      // Simulate logout process
      return _authRemoteDataSource.logout();
    } catch (e) {
      throw FailureConverter.convert(e);
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
  Future register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) {
    try {
      // Simulate register process
      return _authRemoteDataSource.register(name, email, password);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
