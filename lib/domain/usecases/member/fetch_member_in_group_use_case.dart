import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/repositories/member_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchMemberInGroupUseCase
    extends UseCase<List<UserEntity>, FetchMemberInGroupParams> {
  final MemberRepository _memberRepository;

  FetchMemberInGroupUseCase(this._memberRepository);

  @override
  Future<List<UserEntity>> call(FetchMemberInGroupParams params) async {
    return _memberRepository.fetchMembersInGroup(
      workspaceId: params.workspaceId,
    );
  }
}

class FetchMemberInGroupParams {
  final int workspaceId;

  FetchMemberInGroupParams({required this.workspaceId});
}
