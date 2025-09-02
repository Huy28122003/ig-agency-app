import 'package:ig_agency_app/domain/entities/workspace_entity.dart';

abstract class WorkspaceRepository {
  Future<List<WorkspaceEntity>> getWorkspaces({
    required int limit,
    required int offset,
    String? keyWord,
  });

  Stream<WorkspaceEntity> listenLastMessages();
}
