import 'package:ig_agency_app/domain/entities/media_entity.dart';
import 'package:ig_agency_app/domain/repositories/workspace_repository.dart';
import 'package:ig_agency_app/domain/usecases/use_case.dart';
import 'package:ig_agency_app/domain/usecases/workspace/get_data_in_group_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMediasInGroupUseCase
    extends UseCase<List<MediaEntity>, GetDataInGroupParams> {
  GetMediasInGroupUseCase(this._workspaceRepository);

  final GroupRepository _workspaceRepository;

  @override
  Future<List<MediaEntity>> call(
    GetDataInGroupParams param,
  ) async {
    return await _workspaceRepository.getMediasInGroup(
      workspaceId: param.workspaceId,
      offset: param.offset,
      limit: param.limit,
    );
  }
}

