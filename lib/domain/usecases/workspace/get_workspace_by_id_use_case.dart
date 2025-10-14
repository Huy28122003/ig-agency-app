import 'package:ig_agency_app/domain/entities/group_entity.dart';
import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetWorkspaceByIdUseCase extends UseCase<GroupEntity, String> {
  GetWorkspaceByIdUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<GroupEntity> call(String param) async {
    return await _workspaceRepository.getWorkspaceById(groupId: param);
  }
}
