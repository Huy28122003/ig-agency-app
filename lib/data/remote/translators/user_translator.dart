import 'package:ig_agency_app/data/remote/models/response/user_response_model.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/enums/role.dart';

extension UserTranslatorExtension on UserResponseModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      avatar: avatar ?? '',
      isAdmin: RoleSystem.fromString(role).isAdmin,
      isOnline: status == 'active',
    );
  }
}
