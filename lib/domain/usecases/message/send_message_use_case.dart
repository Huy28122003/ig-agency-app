import 'package:ig_agency_app/domain/entities/message/message.dart';
import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../use_case.dart';

@injectable
class SendMessageUseCase extends UseCase<MessageEntity, SendMessageParams> {
  final MessageRepository _messageRepository;

  SendMessageUseCase(this._messageRepository);

  @override
  Future<MessageEntity> call(SendMessageParams params) async {
    return await _messageRepository.sendMessage(params.message);
  }
}

class SendMessageParams {
  final MessageEntity message;

  SendMessageParams({required this.message});
}
