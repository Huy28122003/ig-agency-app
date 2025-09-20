import 'package:ig_agency_app/domain/entities/user/profile_info_entity.dart';

abstract class UserLocalDataSource {
  Future<ProfileInfoEntity?> getProfileInfo();

  Future saveProfileInfo(ProfileInfoEntity profileInfo);
}
