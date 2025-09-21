import 'dart:convert';

import 'package:ig_agency_app/data/local/app/user_local_data_source.dart';
import 'package:ig_agency_app/dependencies/local_storage/local_storage_manager.dart';
import 'package:ig_agency_app/domain/entities/user/profile_info_entity.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserLocalDataSource)
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final LocalStorageManager _localStorageManager;

  UserLocalDataSourceImpl(this._localStorageManager);

  @override
  Future<ProfileInfoEntity?> getProfileInfo() async {
    try {
      final string = await _localStorageManager.getValue<String>(
        LocalStorageKeys.profileInfo,
      );
      if (string.isNullOrEmpty()) return null;
      final map = json.decode(string!);
      return ProfileInfoEntity.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  @override
  Future saveProfileInfo(ProfileInfoEntity profileInfo) async {
    final value = json.encode(profileInfo.toJson());
    return await _localStorageManager.setValue<String>(
      LocalStorageKeys.profileInfo,
      value,
    );
  }
}
