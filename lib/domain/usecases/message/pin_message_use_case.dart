import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:injectable/injectable.dart';

import '../use_case.dart';

@injectable
class PinMessageUseCase extends UseCase<void, PinMessageParams> {
  final GroupRepository _groupRepository;

  PinMessageUseCase(this._groupRepository);

  @override
  Future<void> call(PinMessageParams params) async {
    return await _groupRepository.pinMessage(params.groupId, params.messageId);
  }
}

class PinMessageParams {
  final String groupId;
  final String messageId;

  PinMessageParams({required this.groupId, required this.messageId});
}
