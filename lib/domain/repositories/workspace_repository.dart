import 'package:ig_agency_app/domain/entities/workspace_entity.dart';

import '../../shared/commons/result.dart';

abstract class WorkspaceRepository {
  Future<Result<List<WorkspaceEntity>>> getWorkspaces({
    required int limit,
    required int offset,
    String? keyWord,
  });

  Stream<WorkspaceEntity> listenLastMessages();
}
