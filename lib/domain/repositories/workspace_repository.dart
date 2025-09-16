import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/entities/media_entity.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import '../../shared/commons/models/pagination.dart';

import '../entities/file_entity.dart';

abstract class WorkspaceRepository {
  Future<List<WorkspaceEntity>> getWorkspaces({
    required int limit,
    required int offset,
    String? keyWord,
  });

  Future<WorkspaceEntity> getWorkspaceById({required int groupId});

  Stream<WorkspaceEntity> listenLastMessages();

  Future<bool> updateWorkspaceBio({required int groupId, required String bio});

  Future<List<UserEntity>> getUserInGroup({
    required int workspaceId,
    required int offset,
    required int limit,
  });

  Future<bool> updateWorkspaceNotification({
    required int groupId,
    required bool isMute,
  });

  Future<List<MediaEntity>> getMediasInGroup({
    required int workspaceId,
    required int offset,
    required int limit,
  });

  Future<List<FileEntity>> getFileInGroup({
    required int workspaceId,
    required int offset,
    required int limit,
  });

  Future<List<String>> getLinkInGroup({
    required int workspaceId,
    required int offset,
    required int limit,
  });

  Future<List<UserEntity>> getListUser({
    required Pagination pagination,
    String? keySearch,
  });

  // TODO: tương tự hàm getWorkspaces => quy về dùng chung 1 hàm
  Future<List<WorkspaceEntity>> getListGroup({
    required Pagination pagination,
    String? keySearch,
  });

  Future<bool> createGroup(String groupName, List<UserEntity> members);

  Future<bool> addUserToGroups(UserEntity user, List<WorkspaceEntity> groups);
}
