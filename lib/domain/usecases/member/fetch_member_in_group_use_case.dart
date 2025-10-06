import 'package:ig_agency_app/domain/entities/member_entity.dart';
import 'package:ig_agency_app/domain/repositories/member_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchMemberInGroupUseCase
    extends UseCase<List<MemberEntity>, FetchMemberInGroupParams> {
  final MemberRepository _memberRepository;

  FetchMemberInGroupUseCase(this._memberRepository);

  @override
  Future<List<MemberEntity>> call(FetchMemberInGroupParams params) async {
    return _memberRepository.fetchMembersInGroup(groupId: params.groupId);
  }
}

class FetchMemberInGroupParams {
  final String groupId;

  FetchMemberInGroupParams({required this.groupId});
}
