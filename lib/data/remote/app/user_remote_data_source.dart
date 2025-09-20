import '../models/response/profile_info_response.dart';

abstract class UserRemoteDataSource {
  Future<ProfileInfoResponse> getProfileInfo();
}
