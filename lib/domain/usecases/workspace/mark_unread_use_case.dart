import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../repositories/group_repository.dart';

@injectable
class MarkUnreadUseCase extends UseCase<void, String> {
  MarkUnreadUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<void> call(String groupId) async {
    return await _workspaceRepository.markAsRead(groupId);
  }
}
