import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/repositories/member_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchMemberInWorkspaceUseCase
    extends UseCase<List<UserEntity>, FetchMemberInWorkspaceParams> {
  final MemberRepository _memberRepository;

  FetchMemberInWorkspaceUseCase(this._memberRepository);

  @override
  Future<List<UserEntity>> call(FetchMemberInWorkspaceParams params) async {
    return _memberRepository.fetchMembersInWorkspace(
      workspaceId: params.workspaceId,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class FetchMemberInWorkspaceParams {
  final int workspaceId;
  final int limit;
  final int offset;

  FetchMemberInWorkspaceParams({
    required this.workspaceId,
    this.limit = 10,
    this.offset = 0,
  });
}
