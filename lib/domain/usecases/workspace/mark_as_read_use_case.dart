import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../repositories/group_repository.dart';

@injectable
class MarkAsReadUseCase extends UseCase<void, String> {
  MarkAsReadUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<void> call(String groupId) async {
    return await _workspaceRepository.markAsRead(groupId);
  }
}
