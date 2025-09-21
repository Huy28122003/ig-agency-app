import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../../entities/message/message_content.dart';
import '../use_case.dart';

@injectable
class SendMessageUseCase extends UseCase<void, SendMessageParams> {
  final MessageRepository _messageRepository;

  SendMessageUseCase(this._messageRepository);

  @override
  Future<void> call(SendMessageParams params) async {
    return await _messageRepository.sendMessage(
      params.userId,
      params.groupId,
      params.replyMessageId,
      params.content,
    );
  }
}

class SendMessageParams {
  final String userId;
  final String groupId;
  final String? replyMessageId;
  final MessageContent content;

  SendMessageParams({
    required this.userId,
    required this.groupId,
    required this.replyMessageId,
    required this.content,
  });
}
