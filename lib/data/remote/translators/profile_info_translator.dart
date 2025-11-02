import 'package:ig_agency_app/data/remote/models/response/profile_info_response.dart';
import 'package:ig_agency_app/domain/entities/user/profile_info_entity.dart';
import 'package:ig_agency_app/domain/enums/role.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';

extension UserTranslatorExtension on ProfileInfoResponse {
  ProfileInfoEntity toEntity() {
    return ProfileInfoEntity(
      id: id ?? "",
      name: name ?? '',
      avatar: avatar?.withBaseUrl() ?? '',
      bio: bio ?? '',
      lastActiveAt: DateTime.now(),
      role: RoleSystem.fromString(role ?? ''),
    );
  }
}
