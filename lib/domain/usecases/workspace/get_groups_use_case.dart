import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

import '../../entities/group_summary.dart';
import '../../repositories/group_repository.dart';

@injectable
class GetGroupUseCase
    extends UseCase<List<GroupSummary>, GetWorkspacesParams> {
  GetGroupUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<List<GroupSummary>> call(GetWorkspacesParams param) async {
    return await _workspaceRepository.getGroups(
      limit: param.limit,
      offset: param.offset,
      keyWord: param.keyWord,
    );
  }
}

class GetWorkspacesParams {
  GetWorkspacesParams({
    required this.limit,
    required this.offset,
    this.keyWord,
  });

  final int limit;
  final int offset;
  final String? keyWord;
}