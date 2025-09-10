import 'package:ig_agency_app/domain/entities/paged_result.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUsersByWorkspaceIdUseCase
    extends UseCase<PagedResult<UserEntity>, GetUsersByWorkspaceIdParams> {
  GetUsersByWorkspaceIdUseCase(this._workspaceRepository);

  final WorkspaceRepository _workspaceRepository;

  @override
  Future<PagedResult<UserEntity>> call(
    GetUsersByWorkspaceIdParams param,
  ) async {
    return await _workspaceRepository.getUserByWorkspaceId(
      workspaceId: param.workspaceId,
      offset: param.offset,
      limit: param.limit,
    );
  }
}

class GetUsersByWorkspaceIdParams {
  final int limit;
  final int offset;
  final int workspaceId;

  GetUsersByWorkspaceIdParams({
    required this.limit,
    required this.offset,
    required this.workspaceId,
  });
}
