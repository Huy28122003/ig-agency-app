import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../use_case.dart';

@injectable
class DeleteMessageForYouUseCase
    extends UseCase<void, DeleteMessageForYouParams> {
  final MessageRepository _messageRepository;

  DeleteMessageForYouUseCase(this._messageRepository);

  @override
  Future<void> call(DeleteMessageForYouParams params) async {
    return await _messageRepository.deleteMessageForYou(params.messageId);
  }
}

class DeleteMessageForYouParams {
  final String messageId;

  DeleteMessageForYouParams({required this.messageId});
}
