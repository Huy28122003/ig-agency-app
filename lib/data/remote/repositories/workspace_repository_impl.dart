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
    String? keyWord,
  }) async {
    final allData = MockData.getWorkspaces();

    final filtered = keyWord != null && keyWord.isNotEmpty
        ? allData
              .where(
                (e) => e.workspaceName.toLowerCase().contains(
                  keyWord.toLowerCase(),
                ),
              )
              .toList()
        : allData;

    final start = offset;
    final end = (offset + limit).clamp(0, filtered.length);

    return Result.completed(filtered.sublist(start, end));
  }
}
