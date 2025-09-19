import 'package:ig_agency_app/domain/entities/user_entity.dart';

abstract class MemberRepository {
  Future<List<UserEntity>> fetchMembersInGroup({required int groupId});
  Future<List<UserEntity>> searchMembersInGroup({
    required int groupId,
    required String query,
  });
}
