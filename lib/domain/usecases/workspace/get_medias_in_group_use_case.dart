import 'package:ig_agency_app/domain/entities/media_entity.dart';
import 'package:ig_agency_app/domain/entities/paged_result.dart';
import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_data_in_group_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMediasInGroupUseCase
    extends UseCase<PagedResult<MediaEntity>, GetDataInGroupParams> {
  GetMediasInGroupUseCase(this._workspaceRepository);

  final WorkspaceRepository _workspaceRepository;

  @override
  Future<PagedResult<MediaEntity>> call(
    GetDataInGroupParams param,
  ) async {
    return await _workspaceRepository.getMediasInGroup(
      workspaceId: param.workspaceId,
      offset: param.offset,
      limit: param.limit,
    );
  }
}

