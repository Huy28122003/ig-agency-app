import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:injectable/injectable.dart';

import '../use_case.dart';

@injectable
class UnpinMessageUseCase extends UseCase<void, UnpinMessageParams> {
  final GroupRepository _groupRepository;

  UnpinMessageUseCase(this._groupRepository);

  @override
  Future<void> call(UnpinMessageParams params) async {
    return await _groupRepository.unpinMessage(
      params.groupId,
      params.messageId,
    );
  }
}

class UnpinMessageParams {
  final String groupId;
  final String messageId;

  UnpinMessageParams({required this.groupId, required this.messageId});
}
