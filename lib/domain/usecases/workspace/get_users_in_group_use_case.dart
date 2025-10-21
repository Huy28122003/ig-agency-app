import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_data_in_group_params.dart';
import 'package:injectable/injectable.dart';
import '../../entities/member_entity.dart';
import '../../repositories/group_repository.dart';

@injectable
class GetUsersInGroupUseCase
    extends UseCase<List<MemberEntity>, GetDataInGroupParams> {
  GetUsersInGroupUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<List<MemberEntity>> call(
    GetDataInGroupParams param,
  ) async {
    return await _workspaceRepository.getUserInGroup(
      workspaceId: param.workspaceId,
      offset: param.offset,
      limit: param.limit,
    );
  }
}

