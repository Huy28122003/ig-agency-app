import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:injectable/injectable.dart';

import '../../entities/message/message.dart';
import '../use_case.dart';

@injectable
class FetchPinnedMessageUseCase
    extends UseCase<List<MessageEntity>, FetchPinnedMessageParams> {
  final GroupRepository _groupRepository;

  FetchPinnedMessageUseCase(this._groupRepository);

  @override
  Future<List<MessageEntity>> call(FetchPinnedMessageParams params) async {
    return await _groupRepository.fetchPinnedMessages(
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
