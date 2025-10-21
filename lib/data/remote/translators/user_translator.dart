import 'package:ig_agency_app/data/remote/models/response/user_profile_response_model.dart';
import 'package:ig_agency_app/domain/enums/role.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';
import '../../../../domain/entities/user_entity.dart';

extension UserTranslatorExtension on UserProfileResponseModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id ?? "",
      name: name ?? '',
      avatar: avatar == null ? '' : avatar?.withBaseUrl() ?? '',
      bio: bio ?? '',
      lastActiveAt: DateTime.now(),
      isAdmin: RoleSystem.fromString(role ?? '').isAdmin,
    );
  }
}
