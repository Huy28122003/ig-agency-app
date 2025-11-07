import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';
import '../../repositories/group_repository.dart';

@injectable
class UpdateGroupBioUseCase extends UseCase<void, UpdateGroupBioParams> {
  UpdateGroupBioUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<void> call(UpdateGroupBioParams param) async {
    return await _workspaceRepository.updateGroupBio(
      groupId: param.workspaceId,
      bio: param.bio,
    );
  }
}

class UpdateGroupBioParams {
  final String workspaceId;
  final String bio;

  UpdateGroupBioParams({required this.workspaceId, required this.bio});
}
