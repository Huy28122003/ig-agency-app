import 'package:ig_agency_app/dependencies/local_storage/local_storage_manager.dart';
import 'package:injectable/injectable.dart';

import '../app/auth_local_data_source.dart';

@Injectable(as: AuthLocalDataSource, order: -1)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorageManager _localStorageManager;

  AuthLocalDataSourceImpl(this._localStorageManager);

  @override
  Future<String?> getAccessToken() async {
    return _localStorageManager.getValue<String>(LocalStorageKeys.accessToken);
  }

  @override
  Future<String?> getRefreshToken() {
    // TODO: implement getRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<void> revokeTokens() async {
    return _localStorageManager.deleteKey(LocalStorageKeys.accessToken);
  }

  @override
  Future<void> saveAccessToken(String accessToken) async {
    return _localStorageManager.setValue<String>(
      LocalStorageKeys.accessToken,
      accessToken,
    );
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) {
    // TODO: implement saveRefreshToken
    throw UnimplementedError();
  }
}
