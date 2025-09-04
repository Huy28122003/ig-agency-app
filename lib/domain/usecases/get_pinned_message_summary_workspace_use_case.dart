import 'package:ig_agency_app/domain/repositories/message_repository.dart';
import 'package:injectable/injectable.dart';

import '../entities/pinned_message_summary.dart';
import 'use_case.dart';

@injectable
class GetPinnedMessageSummaryWorkspaceUseCase
    extends
        UseCase<PinnedMessageSummary, GetPinnedMessageSummaryWorkspaceParams> {
  final MessageRepository _messageRepository;

  GetPinnedMessageSummaryWorkspaceUseCase(this._messageRepository);

  @override
  Future<PinnedMessageSummary> call(
    GetPinnedMessageSummaryWorkspaceParams params,
  ) async {
    return await _messageRepository.getPinnedMessageSummaryByGroupId(
      params.workspaceId,
    );
  }
}

class GetPinnedMessageSummaryWorkspaceParams {
  final int workspaceId;

  GetPinnedMessageSummaryWorkspaceParams({required this.workspaceId});
}
