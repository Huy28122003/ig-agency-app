import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../repositories/group_repository.dart';

@injectable
class PinGroupUseCase extends UseCase<void, String> {
  PinGroupUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<void> call(String groupId) async {
    return await _workspaceRepository.pinGroup(groupId);
  }
}
