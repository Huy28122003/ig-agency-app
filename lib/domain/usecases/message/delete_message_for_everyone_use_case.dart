import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:injectable/injectable.dart';

import '../use_case.dart';

@injectable
class DeleteMessageForEveryoneUseCase
    extends UseCase<void, DeleteMessageForEveryoneParams> {
  final GroupRepository _groupRepository;

  DeleteMessageForEveryoneUseCase(this._groupRepository);

  @override
  Future<void> call(DeleteMessageForEveryoneParams params) async {
    return await _groupRepository.deleteMessageForEveryone(
      params.groupId,
      params.messageId,
    );
  }
}

class DeleteMessageForEveryoneParams {
  final String groupId;
  final String messageId;

  DeleteMessageForEveryoneParams({
    required this.groupId,
    required this.messageId,
  });
}
