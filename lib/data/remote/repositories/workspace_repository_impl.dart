import 'package:ig_agency_app/domain/entities/paged_result.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/shared/mock_data.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/workspace_repository.dart';
import '../../../shared/commons/failure_converter.dart';

@Injectable(as: WorkspaceRepository)
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  @override
  Future<PagedResult<WorkspaceEntity>> getWorkspaces({
    required int limit,
    required int offset,
    String? keyWord,
  }) async {
    try {
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

      final total = filtered.length;
      final start = ((offset - 1) * limit).clamp(0, total);
      final end = (start + limit).clamp(0, total);
      final pageData = start < end
          ? filtered.sublist(start, end)
          : <WorkspaceEntity>[];

      return PagedResult<WorkspaceEntity>(data: pageData, totalRecords: total);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Stream<WorkspaceEntity> listenLastMessages() {
    // TODO: implement listenLastMessages
    throw UnimplementedError();
  }

  @override
  Future<WorkspaceEntity> getWorkspaceById({required int groupId}) async {
    try {
      final workspace = MockData.getWorkspaces().firstWhere(
        (element) => element.id == groupId,
      );
      return workspace;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<bool> updateWorkspaceBio({
    required int groupId,
    required String bio,
  }) async {
    return true;
  }
}
