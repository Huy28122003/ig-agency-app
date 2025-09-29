import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateWorkspaceNameUseCase
    extends UseCase<bool, UpdateWorkspaceNameParams> {
  UpdateWorkspaceNameUseCase(this._workspaceRepository);

  final WorkspaceRepository _workspaceRepository;

  @override
  Future<bool> call(UpdateWorkspaceNameParams param) async {
    return await _workspaceRepository.updateWorkspaceName(
      groupId: param.workspaceId,
      name: param.name,
    );
  }
}

class UpdateWorkspaceNameParams {
  final int workspaceId;
  final String name;

  UpdateWorkspaceNameParams({required this.workspaceId, required this.name});
}
