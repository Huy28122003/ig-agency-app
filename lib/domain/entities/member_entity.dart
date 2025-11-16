import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/enums/user_group_role.dart';

class MemberEntity {
  const MemberEntity({required this.user, required this.status});

  final UserEntity user;
  final UserGroupRole status;
}
