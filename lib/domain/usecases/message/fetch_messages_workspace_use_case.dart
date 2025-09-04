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
    return await _messageRepository.fetchMessagesByGroupId(
      params.groupId,
      params.limit,
      params.oldestMessageId,
    );
  }
}

class FetchMessagesWorkspaceParams {
  final int groupId;
  final int limit;
  final String? oldestMessageId;

  FetchMessagesWorkspaceParams({
    required this.groupId,
    required this.limit,
    this.oldestMessageId,
  });
}
