import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';
import '../../repositories/group_repository.dart';

@injectable
class UpdateGroupAvatarUseCase extends UseCase<void, UpdateGroupAvatarParams> {
  UpdateGroupAvatarUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<void> call(UpdateGroupAvatarParams param) async {
    return await _workspaceRepository.updateGroupAvatar(
      groupId: param.workspaceId,
      image: param.image,
    );
  }
}

class UpdateGroupAvatarParams {
  final String workspaceId;
  final String image;

  UpdateGroupAvatarParams({required this.workspaceId, required this.image});
}
