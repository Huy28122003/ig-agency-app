import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateWorkspaceNotificationUseCase
    extends UseCase<bool, UpdateWorkspaceNotificationParams> {
  UpdateWorkspaceNotificationUseCase(this._workspaceRepository);

  final WorkspaceRepository _workspaceRepository;

  @override
  Future<bool> call(UpdateWorkspaceNotificationParams param) async {
    return await _workspaceRepository.updateWorkspaceNotification(
      groupId: param.workspaceId,
      isMute: param.isMute,
    );
  }
}

class UpdateWorkspaceNotificationParams {
  final int workspaceId;
  final bool isMute;

  UpdateWorkspaceNotificationParams({
    required this.workspaceId,
    required this.isMute,
  });
}
