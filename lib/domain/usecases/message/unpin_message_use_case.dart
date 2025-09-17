import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../use_case.dart';

@injectable
class UnpinMessageUseCase extends UseCase<void, UnpinMessageParams> {
  final MessageRepository _messageRepository;

  UnpinMessageUseCase(this._messageRepository);

  @override
  Future<void> call(UnpinMessageParams params) async {
    return await _messageRepository.unpinMessage(params.messageId);
  }
}

class UnpinMessageParams {
  final String messageId;

  UnpinMessageParams({required this.messageId});
}
