import 'package:ig_agency_app/domain/entities/user_entity.dart';

abstract class MemberRepository {
  Future<List<UserEntity>> fetchMembersInGroup({required String groupId});

  Future<List<UserEntity>> searchMembersInGroup({
    required String groupId,
    required String query,
  });
}
