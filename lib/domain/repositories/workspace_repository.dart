import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/entities/paged_result.dart';

abstract class WorkspaceRepository {
  Future<PagedResult<WorkspaceEntity>> getWorkspaces({
    required int limit,
    required int offset,
    String? keyWord,
  });

  Future<WorkspaceEntity> getWorkspaceById({required int groupId});

  Stream<WorkspaceEntity> listenLastMessages();

  Future<bool> updateWorkspaceBio({required int groupId, required String bio});

  Future<PagedResult<UserEntity>> getUserByWorkspaceId({
    required int workspaceId,
    required int offset,
    required int limit,
  });
}
