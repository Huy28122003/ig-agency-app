import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetWorkspaceByIdUseCase extends UseCase<WorkspaceEntity, int> {
  GetWorkspaceByIdUseCase(this._workspaceRepository);

  final WorkspaceRepository _workspaceRepository;

  @override
  Future<WorkspaceEntity> call(int param) async {
    return await _workspaceRepository.getWorkspaceById(groupId: param);
  }
}
