import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/entities/paged_result.dart';

abstract class WorkspaceRepository {
  Future<PagedResult<WorkspaceEntity>> getWorkspaces({
    required int limit,
    required int offset,
    String? keyWord,
  });

  Stream<WorkspaceEntity> listenLastMessages();
}