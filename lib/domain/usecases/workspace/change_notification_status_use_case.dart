import 'package:ig_agency_app/domain/enums/unmute_time_enum.dart';
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
      groupId: params.groupId,
      enable: params.enable,
      option: params.option,
    );
  }
}

class ChangeNotificationStatusParams {
  ChangeNotificationStatusParams({
    required this.groupId,
    required this.enable,
    this.option,
  });

  final String groupId;
  final bool enable;
  final MuteDurationOption? option;
}
