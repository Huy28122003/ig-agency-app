import 'package:injectable/injectable.dart';

import '../app/auth_local_data_source.dart';

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<String?> getAccessToken() {
    // TODO: implement getAccessToken
    throw UnimplementedError();
  }

  @override
  Future<String?> getRefreshToken() {
    // TODO: implement getRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<void> revokeTokens() {
    // TODO: implement revokeTokens
    throw UnimplementedError();
  }

  @override
  Future<void> saveAccessToken(String accessToken) {
    // TODO: implement saveAccessToken
    throw UnimplementedError();
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) {
    // TODO: implement saveRefreshToken
    throw UnimplementedError();
  }
}
