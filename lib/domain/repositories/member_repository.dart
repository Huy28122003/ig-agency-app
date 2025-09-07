import 'package:ig_agency_app/domain/entities/user_entity.dart';

abstract class MemberRepository {
  Future<List<UserEntity>> fetchMembersInWorkspace({
    required int workspaceId,
    required int limit,
    required int offset,
  });
  Future<List<UserEntity>> searchMembersInWorkspace({
    required int workspaceId,
    String? query,
  });
}
