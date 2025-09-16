import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../../entities/message/message.dart';
import '../use_case.dart';

@injectable
class FetchMessagesWorkspaceUseCase
    extends UseCase<List<MessageEntity>, FetchMessagesWorkspaceParams> {
  final MessageRepository _messageRepository;

  FetchMessagesWorkspaceUseCase(this._messageRepository);

  @override
  Future<List<MessageEntity>> call(FetchMessagesWorkspaceParams params) async {
    return await _messageRepository.fetchMessagesInGroup(
      params.workspaceId,
      params.limit,
      params.oldestMessageId,
      params.targetMessageId,
    );
  }
}

class FetchMessagesWorkspaceParams {
  final int workspaceId;
  final int limit;
  final String? oldestMessageId;
  final String? targetMessageId;

  FetchMessagesWorkspaceParams({
    required this.workspaceId,
    required this.limit,
    this.oldestMessageId,
    this.targetMessageId,
  });
}
