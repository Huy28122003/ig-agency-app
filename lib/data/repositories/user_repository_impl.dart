import 'dart:async';
import 'package:ig_agency_app/data/local/app/user_local_data_source.dart';
import 'package:ig_agency_app/data/remote/app/user_remote_data_source.dart';
import 'package:ig_agency_app/data/remote/translators/profile_info_translator.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user/profile_info_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../shared/commons/failure_converter.dart';
import '../cache/ram_cache.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._ramCache, this._remote, this._local);

  final UserRemoteDataSource _remote;
  final UserLocalDataSource _local;
  final RamCache _ramCache;

  @override
  Stream<ProfileInfoEntity> get fetchProfileInfo =>
      _ramCache.fetchProfileInfo();

  @override
  Future<ProfileInfoEntity> getProfileInfo([bool isForceFetch = false]) async {
    try {
      ProfileInfoEntity? profileInfo;
      final localInfo = await _local.getProfileInfo();
      if (localInfo == null || isForceFetch) {
        final response = await _remote.getProfileInfo();
        profileInfo = response.toEntity();
        _local.saveProfileInfo(profileInfo);
      } else {
        profileInfo = localInfo;
      }
      _ramCache.saveProfileInfo(profileInfo);

      return profileInfo;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future updateProfileInfo(ProfileInfoEntity user) async {
    try {
      _ramCache.saveProfileInfo(user);
      return;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future updateUsername(String name) async {
    try {
      final response = await _remote.updateName(name: name);
      final profileInfo = response.toEntity();
      _local.saveProfileInfo(profileInfo);
      _ramCache.saveProfileInfo(profileInfo);
      return;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future updateProfileBio(String bio) async {
    try {
      final response = await _remote.updateBio(bio: bio);
      final profileInfo = response.toEntity();
      _local.saveProfileInfo(profileInfo);
      _ramCache.saveProfileInfo(profileInfo);
      return;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<UserEntity> getUserInfo(String userId) async {
    try {
      final user = _ramCache.getLatestProfileInfo();
      if (user == null) {
        throw Exception('User not found');
      }
      return UserEntity(
        id: "id",
        name: "Nguyễn Văn Quang",
        email: "email",
        avatar:
            "https://media.istockphoto.com/id/814423752/vi/anh/con-m%E1%BA%AFt-c%E1%BB%A7a-ng%C6%B0%E1%BB%9Di-m%E1%BA%ABu-v%E1%BB%9Bi-trang-%C4%91i%E1%BB%83m-ngh%E1%BB%87-thu%E1%BA%ADt-%C4%91%E1%BA%A7y-m%C3%A0u-s%E1%BA%AFc-c%E1%BA%ADn-c%E1%BA%A3nh.jpg?s=1024x1024&w=is&k=20&c=g9JektNW0igwf2u2mT9uqSLkhzR91ZYviuVLXuhy2JQ=",
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
