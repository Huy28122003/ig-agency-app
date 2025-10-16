import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';
import '../../repositories/group_repository.dart';

@injectable
class UpdateWorkspaceBioUseCase
    extends UseCase<bool, UpdateWorkspaceBioParams> {
  UpdateWorkspaceBioUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<bool> call(UpdateWorkspaceBioParams param) async {
    return await _workspaceRepository.updateGroupBio(
      groupId: param.workspaceId,
      bio: param.bio,
    );
  }
}

class UpdateWorkspaceBioParams {
  final String workspaceId;
  final String bio;

  UpdateWorkspaceBioParams({required this.workspaceId, required this.bio});
}
