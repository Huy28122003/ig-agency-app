import '../models/response/profile_info_response.dart';

abstract class UserRemoteDataSource {
  Future<ProfileInfoResponse> getProfileInfo();

  Future<ProfileInfoResponse> updateName({String? name});

  Future<ProfileInfoResponse> updateBio({String? bio});
}
