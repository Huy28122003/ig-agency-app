import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../../entities/message/message.dart';
import '../use_case.dart';

@injectable
class FetchPinnedMessageInGroupUseCase
    extends UseCase<List<MessageEntity>, FetchPinnedMessageInGroupParams> {
  final MessageRepository _messageRepository;

  FetchPinnedMessageInGroupUseCase(this._messageRepository);

  @override
  Future<List<MessageEntity>> call(
    FetchPinnedMessageInGroupParams params,
  ) async {
    return await _messageRepository.fetchPinnedMessagesInGroup(
      params.groupId,
      params.limit,
      params.offset,
    );
  }
}

class FetchPinnedMessageInGroupParams {
  final int groupId;
  final int limit;
  final int offset;

  FetchPinnedMessageInGroupParams({
    required this.groupId,
    required this.limit,
    required this.offset,
  });
}
