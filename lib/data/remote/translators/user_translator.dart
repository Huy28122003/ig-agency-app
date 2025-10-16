import 'package:ig_agency_app/data/remote/models/response/user_profile_response_model.dart';
import 'package:ig_agency_app/domain/enums/role.dart';

import '../../../../domain/entities/user_entity.dart';

extension UserTranslatorExtension on UserProfileResponseModel {
  UserEntity toEntity() {
    return UserEntity(
      id: user.id ?? "",
      name: user.name ?? '',
      avatar: user.avatar ?? '',
      bio: user.bio ?? '',
      lastActiveAt: DateTime.now(),
      isAdmin: RoleSystem.fromString(user.role ?? '').isAdmin,
    );
  }
}
