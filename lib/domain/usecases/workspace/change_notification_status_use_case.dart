import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../repositories/group_repository.dart';

@injectable
class ChangeNotificationStatusUseCase
    extends UseCase<void, ChangeNotificationStatusParams> {
  ChangeNotificationStatusUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<void> call(ChangeNotificationStatusParams params) async {
    return await _workspaceRepository.changeNotificationStatus(
      params.groupId,
      params.enable,
    );
  }
}

class ChangeNotificationStatusParams {
  ChangeNotificationStatusParams({required this.groupId, required this.enable});

  final String groupId;
  final bool enable;
}
