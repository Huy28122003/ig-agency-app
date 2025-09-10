import 'package:ig_agency_app/domain/entities/paged_result.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/workspace_repository.dart';
import '../../../shared/commons/failure_converter.dart';
import '../../../shared/utils/mock_data.dart';

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
    try {
      return true;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
  @override
  Future<bool> updateWorkspaceNotification({
    required int groupId,
    required bool isMute,
  }) async {
    try {
      return true;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<PagedResult<UserEntity>> getUserByWorkspaceId({
    required int workspaceId,
    required int offset,
    required int limit,
  }) {
    try {
      return MockData().getUsers();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
