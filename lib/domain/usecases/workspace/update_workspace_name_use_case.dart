import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../repositories/group_repository.dart';

@injectable
class UpdateWorkspaceNameUseCase
    extends UseCase<void, UpdateWorkspaceNameParams> {
  UpdateWorkspaceNameUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<void> call(UpdateWorkspaceNameParams param) async {
    return await _workspaceRepository.updateGroupName(
      groupId: param.workspaceId,
      name: param.name,
    );
  }
}

class UpdateWorkspaceNameParams {
  final String workspaceId;
  final String name;

  UpdateWorkspaceNameParams({required this.workspaceId, required this.name});
}
