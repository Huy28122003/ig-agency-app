import 'package:ig_agency_app/domain/repositories/group_repository.dart';
import 'package:injectable/injectable.dart';

import '../../entities/message/message.dart';
import '../use_case.dart';

@injectable
class SearchMessageInGroupUseCase
    extends UseCase<List<MessageEntity>, SearchMessageInGroupParams> {
  final GroupRepository _groupRepository;

  SearchMessageInGroupUseCase(this._groupRepository);

  @override
  Future<List<MessageEntity>> call(SearchMessageInGroupParams params) async {
    return await _groupRepository.searchMessageInWorkspace(
      limit: params.limit,
      offset: params.offset,
      searchMessage: params.searchMessage,
      workspaceId: params.workspaceId,
    );
  }
}

class SearchMessageInGroupParams {
  final String workspaceId;
  final int? limit;
  final int? offset;
  final String searchMessage;

  SearchMessageInGroupParams({
    required this.workspaceId,
    this.limit,
    required this.searchMessage,
    this.offset,
  });
}
