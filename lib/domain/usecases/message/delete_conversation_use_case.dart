import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:injectable/injectable.dart';

import '../use_case.dart';

@injectable
class DeleteConversationUseCase
    extends UseCase<void, DeleteConversationParams> {
  final GroupRepository _groupRepository;

  DeleteConversationUseCase(this._groupRepository);

  @override
  Future<void> call(DeleteConversationParams params) async {
    return await _groupRepository.deleteConversation(params.groupId);
  }
}

class DeleteConversationParams {
  final String groupId;

  DeleteConversationParams({required this.groupId});
}
