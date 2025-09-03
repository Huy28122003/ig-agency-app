import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../../entities/message/message.dart';
import '../../entities/paged_result.dart';
import '../use_case.dart';

@injectable
class FetchMessageUseCase
    extends UseCase<PagedResult<MessageEntity>, FetchMessageParams> {
  final MessageRepository _messageRepository;

  FetchMessageUseCase(this._messageRepository);

  @override
  Future<PagedResult<MessageEntity>> call(FetchMessageParams params) async {
    return await _messageRepository.fetchPinnedMessages(
      params.limit,
      params.offset,
    );
  }
}

class FetchMessageParams {
  final int limit;
  final int offset;

  FetchMessageParams({required this.limit, required this.offset});
}
