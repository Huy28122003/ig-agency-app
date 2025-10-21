import 'package:ig_agency_app/domain/entities/user_entity.dart';

class MemberEntity {
  const MemberEntity({required this.user, required this.status});

  final UserEntity user;
  final String status;
}
