import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../../entities/pinned_message_summary.dart';
import '../use_case.dart';

@injectable
class GetPinnedMessageSummaryGroupUseCase
    extends UseCase<PinnedMessageSummary, GetPinnedMessageSummaryGroupParams> {
  final MessageRepository _messageRepository;

  GetPinnedMessageSummaryGroupUseCase(this._messageRepository);

  @override
  Future<PinnedMessageSummary> call(
    GetPinnedMessageSummaryGroupParams params,
  ) async {
    return await _messageRepository.getPinnedMessageSummaryInGroup(
      params.groupId,
    );
  }
}

class GetPinnedMessageSummaryGroupParams {
  final int groupId;

  GetPinnedMessageSummaryGroupParams({required this.groupId});
}
