import 'package:ig_agency_app/domain/entities/member_entity.dart';
import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchMemberInGroupUseCase
    extends UseCase<List<MemberEntity>, FetchMemberInGroupParams> {
  final GroupRepository _groupRepository;

  FetchMemberInGroupUseCase(this._groupRepository);

  @override
  Future<List<MemberEntity>> call(FetchMemberInGroupParams params) async {
    return _groupRepository.fetchMembersInGroup(
      groupId: params.groupId,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class FetchMemberInGroupParams {
  final String groupId;
  final int limit;
  final int offset;

  FetchMemberInGroupParams({
    required this.groupId,
    this.limit = 10,
    this.offset = 0,
  });
}
