import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';
import '../../repositories/group_repository.dart';

@injectable
class LeaveGroupUseCase extends UseCase<void, LeaveGroupParams> {
  LeaveGroupUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<void> call(LeaveGroupParams param) async {
    return await _workspaceRepository.leaveGroup(param.groupId, param.userId);
  }
}

class LeaveGroupParams {
  LeaveGroupParams({required this.groupId, required this.userId});

  final String groupId;
  final String userId;
}
