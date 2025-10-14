import 'package:ig_agency_app/domain/entities/member_entity.dart';
import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchMemberInGroupUseCase
    extends UseCase<List<MemberEntity>, SearchMemberInGroupParams> {
  final GroupRepository _groupRepository;

  SearchMemberInGroupUseCase(this._groupRepository);

  @override
  Future<List<MemberEntity>> call(SearchMemberInGroupParams params) async {
    return _groupRepository.searchMembersInGroup(
      groupId: params.groupId,
      query: params.query,
    );
  }
}

class SearchMemberInGroupParams {
  final String groupId;
  final String query;

  SearchMemberInGroupParams({required this.groupId, required this.query});
}
