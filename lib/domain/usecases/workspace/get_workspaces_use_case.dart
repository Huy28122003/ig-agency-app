import 'package:ig_agency_app/domain/entities/paged_result.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetWorkspacesUseCase
    extends UseCase<List<WorkspaceEntity>, GetWorkspacesParams> {
  GetWorkspacesUseCase(this._workspaceRepository);

  final WorkspaceRepository _workspaceRepository;

  @override
  Future<List<WorkspaceEntity>> call(GetWorkspacesParams param) async {
    return await _workspaceRepository.getWorkspaces(
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