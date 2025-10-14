import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:injectable/injectable.dart';

import '../../entities/message/message.dart';
import '../use_case.dart';

@injectable
class SendMessageUseCase extends UseCase<MessageEntity, SendMessageParams> {
  final GroupRepository _groupRepository;

  SendMessageUseCase(this._groupRepository);

  @override
  Future<MessageEntity> call(SendMessageParams params) async {
    return await _groupRepository.sendMessage(
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
