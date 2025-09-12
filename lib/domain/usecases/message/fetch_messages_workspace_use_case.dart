import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../../entities/message/message.dart';
import '../../entities/paged_result.dart';
import '../use_case.dart';

@injectable
class FetchMessagesWorkspaceUseCase
    extends UseCase<PagedResult<MessageEntity>, FetchMessagesWorkspaceParams> {
  final MessageRepository _messageRepository;

  FetchMessagesWorkspaceUseCase(this._messageRepository);

  @override
  Future<PagedResult<MessageEntity>> call(
    FetchMessagesWorkspaceParams params,
  ) async {
    return await _messageRepository.fetchMessagesByWorkspaceId(
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
