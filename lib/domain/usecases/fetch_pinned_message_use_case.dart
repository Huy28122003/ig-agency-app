import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../../shared/commons/result.dart';
import '../entities/message/message.dart';
import 'use_case.dart';

@injectable
class FetchPinnedMessageUseCase
    extends UseCase<List<MessageEntity>, FetchPinnedMessageParams> {
  final MessageRepository _messageRepository;

  FetchPinnedMessageUseCase(this._messageRepository);

  @override
  Future<Result<List<MessageEntity>>> call(
    FetchPinnedMessageParams params,
  ) async {
    return await _messageRepository.getPinnedMessages(
      params.limit,
      params.offset,
    );
  }
}

class FetchPinnedMessageParams {
  final int limit;
  final int offset;

  FetchPinnedMessageParams({required this.limit, required this.offset});
}
