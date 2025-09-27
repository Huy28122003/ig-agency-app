import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../use_case.dart';

@injectable
class DeleteMessageForEveryoneUseCase
    extends UseCase<void, DeleteMessageForEveryoneParams> {
  final MessageRepository _messageRepository;

  DeleteMessageForEveryoneUseCase(this._messageRepository);

  @override
  Future<void> call(DeleteMessageForEveryoneParams params) async {
    return await _messageRepository.deleteMessageForEveryone(
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
