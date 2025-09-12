import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/entities/paged_result.dart';

import '../../shared/commons/models/pagination.dart';
import '../entities/user_entity.dart';

abstract class WorkspaceRepository {
  Future<PagedResult<WorkspaceEntity>> getWorkspaces({
    required int limit,
    required int offset,
    String? keyWord,
  });

  // TODO: tương tự hàm getWorkspaces => quy về dùng chung 1 hàm
  Future<List<WorkspaceEntity>> getListGroup({
    required Pagination pagination,
    String? keySearch,
  });

  Stream<WorkspaceEntity> listenLastMessages();

  Future<List<UserEntity>> getListUser({
    required Pagination pagination,
    String? keySearch,
  });

  Future<bool> createGroup(String groupName, List<UserEntity> members);

  Future<bool> addUserToGroups(UserEntity user, List<WorkspaceEntity> groups);
}
