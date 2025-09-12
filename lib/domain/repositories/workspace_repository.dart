import 'package:ig_agency_app/domain/entities/media_entity.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/domain/entities/paged_result.dart';

import '../../shared/commons/models/pagination.dart';
import '../entities/user_entity.dart';

import '../entities/file_entity.dart';

abstract class WorkspaceRepository {
  Future<PagedResult<WorkspaceEntity>> getWorkspaces({
    required int limit,
    required int offset,
    String? keyWord,
  });

  Future<WorkspaceEntity> getWorkspaceById({required int groupId});

  Stream<WorkspaceEntity> listenLastMessages();

  Future<bool> updateWorkspaceBio({required int groupId, required String bio});

  Future<PagedResult<UserEntity>> getUserInGroup({
    required int workspaceId,
    required int offset,
    required int limit,
  });

  Future<bool> updateWorkspaceNotification({
    required int groupId,
    required bool isMute,
  });

  Future<PagedResult<MediaEntity>> getMediasInGroup({
    required int workspaceId,
    required int offset,
    required int limit,
  });

  Future<PagedResult<FileEntity>> getFileInGroup({
    required int workspaceId,
    required int offset,
    required int limit,
  });

  Future<PagedResult<String>> getLinkInGroup({
    required int workspaceId,
    required int offset,
    required int limit,
  });

  Future<List<UserEntity>> getListUser({
    required Pagination pagination,
    String? keySearch,
  });

  Future<bool> createGroup(String groupName, List<UserEntity> members);
}
