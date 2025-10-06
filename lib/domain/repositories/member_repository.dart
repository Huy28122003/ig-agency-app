import 'package:ig_agency_app/domain/entities/member_entity.dart';

abstract class MemberRepository {
  Future<List<MemberEntity>> fetchMembersInGroup({required String groupId});

  Future<List<MemberEntity>> searchMembersInGroup({
    required String groupId,
    required String query,
  });
}
