import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';
import '../../../shared/commons/result.dart';

@injectable
class GetWorkspacesUseCase
    extends UseCase<List<WorkspaceEntity>, GetWorkspacesParams> {
  GetWorkspacesUseCase(this._workspaceRepository);

  final WorkspaceRepository _workspaceRepository;

  @override
  Future<Result<List<WorkspaceEntity>>> call(GetWorkspacesParams param) async {
    return await _workspaceRepository.getWorkspaces(
      limit: param.limit,
      offset: param.offset,
    );
  }
}

class GetWorkspacesParams {
  GetWorkspacesParams({required this.limit, required this.offset});

  final int limit;
  final int offset;
}
