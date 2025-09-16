import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../entities/message/message.dart';
import '../entities/paged_result.dart';
import 'use_case.dart';

@injectable
class FetchPinnedMessageUseCase
    extends UseCase<PagedResult<MessageEntity>, FetchPinnedMessageParams> {
  final MessageRepository _messageRepository;

  FetchPinnedMessageUseCase(this._messageRepository);

  @override
  Future<PagedResult<MessageEntity>> call(
    FetchPinnedMessageParams params,
  ) async {
    final workspaceId = params.workspaceId;
    if (workspaceId != null) {
      return await _messageRepository.fetchPinnedMessagesByWorkspaceId(
        workspaceId,
        params.limit,
        params.offset,
      );
    }
    return await _messageRepository.fetchPinnedMessages(
      params.limit,
      params.offset,
    );
  }
}

class FetchPinnedMessageParams {
  final int? workspaceId;
  final int limit;
  final int offset;

  FetchPinnedMessageParams({
    required this.limit,
    required this.offset,
    this.workspaceId,
  });
}
