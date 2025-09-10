import 'package:ig_agency_app/data/remote/services/mock/message_mock_service.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/repositories/member_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MemberRepository)
class MemberRepositoryImpl implements MemberRepository {
  final MessageMockService _messageMockService;

  MemberRepositoryImpl(this._messageMockService);

  @override
  Future<List<UserEntity>> fetchMembersInWorkspace({
    required int workspaceId,
    required int limit,
    required int offset,
  }) async {
    return _messageMockService.mockGetMemberInGroup(
      workspaceId,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<UserEntity>> searchMembersInWorkspace({
    required int workspaceId,
    required String query,
  }) async {
    return _messageMockService.mockSearchMemberInGroup(workspaceId, query);
  }
}
