import 'package:ig_agency_app/domain/entities/user_entity.dart';

abstract class MemberRepository {
  Future<List<UserEntity>> fetchMembersInGroup({
    required int workspaceId,
    required int limit,
    required int offset,
  });
  Future<List<UserEntity>> searchMembersInGroup({
    required int workspaceId,
    required String query,
  });
}
