import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/repositories/member_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchMemberInGroupUseCase
    extends UseCase<List<UserEntity>, SearchMemberInGroupParams> {
  final MemberRepository _memberRepository;

  SearchMemberInGroupUseCase(this._memberRepository);

  @override
  Future<List<UserEntity>> call(SearchMemberInGroupParams params) async {
    return _memberRepository.searchMembersInGroup(
      workspaceId: params.workspaceId,
      query: params.query,
    );
  }
}

class SearchMemberInGroupParams {
  final int workspaceId;
  final String query;

  SearchMemberInGroupParams({required this.workspaceId, required this.query});
}
