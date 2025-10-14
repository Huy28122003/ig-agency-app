import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:injectable/injectable.dart';

import '../use_case.dart';

@injectable
class DeleteMessageForYouUseCase
    extends UseCase<void, DeleteMessageForYouParams> {
  final GroupRepository _groupRepository;

  DeleteMessageForYouUseCase(this._groupRepository);

  @override
  Future<void> call(DeleteMessageForYouParams params) async {
    return await _groupRepository.deleteMessageForYou(
      params.groupId,
      params.messageId,
    );
  }
}

class DeleteMessageForYouParams {
  final String groupId;
  final String messageId;

  DeleteMessageForYouParams({required this.groupId, required this.messageId});
}
