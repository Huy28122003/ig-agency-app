import '../models/response/member_response_model.dart';

abstract class MemberRemoteDataSource {
  Future<List<MemberResponseModel>> fetchMembersInGroup({
    required String groupId,
  });

  Future<List<MemberResponseModel>> searchMembersInGroup({
    required String groupId,
    required String query,
  });
}
