import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/shared/mock_data.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/workspace_repository.dart';
import '../../../shared/commons/failure_converter.dart';

@Injectable(as: WorkspaceRepository)
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  @override
  Future<List<WorkspaceEntity>> getWorkspaces({
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

      final start = (offset - 1) * limit;
      final end = (start + limit).clamp(0, filtered.length);
      return filtered.sublist(start, end);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Stream<WorkspaceEntity> listenLastMessages() {
    // TODO: implement listenLastMessages
    throw UnimplementedError();
  }
}
