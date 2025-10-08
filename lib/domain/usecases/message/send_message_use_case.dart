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
      params.groupId,
      params.clientMessageId,
      params.replyMessageId,
      params.content,
    );
  }
}

class SendMessageParams {
  final String groupId;
  final String? clientMessageId;
  final String? replyMessageId;
  final MessageContent content;

  SendMessageParams({
    required this.groupId,
    this.clientMessageId,
    this.replyMessageId,
    required this.content,
  });
}
