import 'package:ig_agency_app/data/remote/models/response/user_profile_response_model.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/enums/activity_status.dart';
import 'package:ig_agency_app/domain/enums/role.dart';

extension UserProfileTranslator on UserProfileResponseModel {
  UserEntity toEntity() {
    return UserEntity(
      id: user.id ?? '',
      name: user.name ?? '',
      avatar: user.avatar ?? '',
      bio: user.bio ?? '',
      isAdmin: RoleSystem.fromString(user.role ?? 'user') == RoleSystem.admin,
      isOnline:
          ActivityStatus.fromString(user.status ?? 'offline') ==
          ActivityStatus.offline,
    );
  }
}
