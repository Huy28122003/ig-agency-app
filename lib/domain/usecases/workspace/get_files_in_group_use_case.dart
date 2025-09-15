import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_data_in_group_params.dart';
import 'package:injectable/injectable.dart';

import '../../entities/file_entity.dart';

@injectable
class GetFilesInGroupUseCase
    extends UseCase<List<FileEntity>, GetDataInGroupParams> {
  GetFilesInGroupUseCase(this._workspaceRepository);

  final WorkspaceRepository _workspaceRepository;

  @override
  Future<List<FileEntity>> call(GetDataInGroupParams param) async {
    return await _workspaceRepository.getFileInGroup(
      workspaceId: param.workspaceId,
      offset: param.offset,
      limit: param.limit,
    );
  }
}
