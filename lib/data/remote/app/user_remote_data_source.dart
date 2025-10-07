import 'package:dio/dio.dart';

import '../../../domain/entities/user/profile_info_entity.dart';
import '../models/response/profile_info_response.dart';

abstract class UserRemoteDataSource {
  Future<ProfileInfoResponse> getProfileInfo();

  Future<ProfileInfoEntity> updateProfile({
    String? name,
    String? bio,
    MultipartFile? avatar,
  });
}
