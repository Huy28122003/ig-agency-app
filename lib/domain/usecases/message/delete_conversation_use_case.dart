import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../use_case.dart';

@injectable
class DeleteConversationUseCase
    extends UseCase<void, DeleteConversationParams> {
  final MessageRepository _messageRepository;

  DeleteConversationUseCase(this._messageRepository);

  @override
  Future<void> call(DeleteConversationParams params) async {
    return await _messageRepository.deleteConversation(params.groupId);
  }
}

class DeleteConversationParams {
  final int groupId;

  DeleteConversationParams({required this.groupId});
}
