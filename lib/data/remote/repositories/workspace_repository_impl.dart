import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/shared/mock_data.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/workspace_repository.dart';
import '../../../shared/commons/result.dart';

@Injectable(as: WorkspaceRepository)
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  @override
  Future<Result<List<WorkspaceEntity>>> getWorkspaces({
    required int limit,
    required int offset,
  }) async {
    return Result.completed(MockData.getWorkspaces().sublist(offset,limit));
  }
}
