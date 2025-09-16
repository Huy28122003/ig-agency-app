import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../use_case.dart';

@injectable
class SendMessageUseCase extends UseCase<void, SendMessageParams> {
  final MessageRepository _messageRepository;

  SendMessageUseCase(this._messageRepository);

  @override
  Future<void> call(SendMessageParams params) async {
    return await _messageRepository.sendMessage(
      params.userId,
      params.workspaceId,
      params.replyMessageId,
      params.content,
    );
  }
}

class SendMessageParams {
  final String userId;
  final int workspaceId;
  final String? replyMessageId;
  final dynamic content;

  SendMessageParams({
    required this.workspaceId,
    required this.userId,
    required this.replyMessageId,
    required this.content,
  });
}
