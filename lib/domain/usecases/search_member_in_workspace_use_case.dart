import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/repositories/member_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchMemberInWorkspaceUseCase
    extends UseCase<List<UserEntity>, SearchMemberInWorkspaceParams> {
  final MemberRepository _memberRepository;

  SearchMemberInWorkspaceUseCase(this._memberRepository);

  @override
  Future<List<UserEntity>> call(SearchMemberInWorkspaceParams params) async {
    return _memberRepository.searchMembersInWorkspace(
      workspaceId: params.workspaceId,
      query: params.query,
    );
  }
}

class SearchMemberInWorkspaceParams {
  final int workspaceId;
  final String? query;

  SearchMemberInWorkspaceParams({required this.workspaceId, this.query});
}
