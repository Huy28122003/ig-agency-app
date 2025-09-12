import 'package:ig_agency_app/domain/entities/paged_result.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_data_in_group_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUsersInGroupUseCase
    extends UseCase<PagedResult<UserEntity>, GetDataInGroupParams> {
  GetUsersInGroupUseCase(this._workspaceRepository);

  final WorkspaceRepository _workspaceRepository;

  @override
  Future<PagedResult<UserEntity>> call(
    GetDataInGroupParams param,
  ) async {
    return await _workspaceRepository.getUserInGroup(
      workspaceId: param.workspaceId,
      offset: param.offset,
      limit: param.limit,
    );
  }
}

