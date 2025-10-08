import 'package:ig_agency_app/data/remote/services/mock/message_mock_service.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/repositories/member_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MemberRepository)
class MemberRepositoryImpl implements MemberRepository {
  final MessageMockService _messageMockService;

  MemberRepositoryImpl(this._messageMockService);

  @override
  Future<List<UserEntity>> fetchMembersInGroup({required String groupId}) async {
    return _messageMockService.mockGetMemberInGroup(groupId);
  }

  @override
  Future<List<UserEntity>> searchMembersInGroup({
    required String groupId,
    required String query,
  }) async {
    return _messageMockService.mockSearchMemberInGroup(groupId, query);
  }
}
