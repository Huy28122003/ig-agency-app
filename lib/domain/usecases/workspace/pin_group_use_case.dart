import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class PinGroupUseCase extends UseCase<void, String> {
  PinGroupUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<void> call(String groupId) async {
    return await _workspaceRepository.pinWorkspace(groupId);
  }
}
