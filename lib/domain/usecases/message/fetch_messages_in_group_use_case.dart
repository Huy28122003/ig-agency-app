import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../../entities/message/message.dart';
import '../use_case.dart';

@injectable
class FetchMessagesInGroupUseCase
    extends UseCase<List<MessageEntity>, FetchMessagesInGroupParams> {
  final MessageRepository _messageRepository;

  FetchMessagesInGroupUseCase(this._messageRepository);

  @override
  Future<List<MessageEntity>> call(FetchMessagesInGroupParams params) async {
    return await _messageRepository.fetchMessagesInGroup(
      params.groupId,
      params.limit,
      params.beforeMessageId,
      params.targetMessageId,
    );
  }
}

class FetchMessagesInGroupParams {
  final String groupId;
  final int limit;
  final String? beforeMessageId;
  final String? targetMessageId;

  FetchMessagesInGroupParams({
    required this.groupId,
    required this.limit,
    this.beforeMessageId,
    this.targetMessageId,
  });
}
