import 'package:ig_agency_app/data/remote/models/response/user_profile_response_model.dart';
import 'package:ig_agency_app/domain/enums/user_role.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../domain/enums/activity_status.dart';

extension UserTranslatorExtension on UserProfileResponseModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id ?? "",
      name: name ?? '',
      avatar: avatar?.withBaseUrl() ?? '',
      bio: bio ?? '',
      lastActiveAt: DateTime.now(),
      isAdmin: UserRole.fromString(role ?? '').isAdmin,
      isOnline:
          ActivityStatus.fromString(status ?? 'offline') ==
          ActivityStatus.offline,
    );
  }
}
