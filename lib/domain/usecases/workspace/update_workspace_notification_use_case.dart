import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../repositories/group_repository.dart';

@injectable
class UpdateWorkspaceNotificationUseCase
    extends UseCase<bool, UpdateWorkspaceNotificationParams> {
  UpdateWorkspaceNotificationUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<bool> call(UpdateWorkspaceNotificationParams param) async {
    return await _workspaceRepository.updateGroupNotification(
      groupId: param.workspaceId,
      isMute: param.isMute,
    );
  }
}

class UpdateWorkspaceNotificationParams {
  final String workspaceId;
  final bool isMute;

  UpdateWorkspaceNotificationParams({
    required this.workspaceId,
    required this.isMute,
  });
}
