import 'package:ig_agency_app/domain/entities/file_entity.dart';
import 'package:ig_agency_app/domain/entities/media_entity.dart';
import 'package:ig_agency_app/domain/entities/paged_result.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/shared/commons/models/pagination.dart';
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
  Future<bool> createGroup(String groupName, List<UserEntity> members) {
    return Future.value(true);
  }

  @override
  Future<List<UserEntity>> getListUser({
    required Pagination pagination,
    String? keySearch,
  }) {
    return Future.value([
      UserEntity(id: "1", name: "Pham Phu", email: '', isAdmin: false),
      UserEntity(id: "2", name: "Nguyen Van A", email: '', isAdmin: false),
      UserEntity(id: "3", name: "Le Thi B", email: '', isAdmin: false),
      UserEntity(id: "4", name: "Tran Van C", email: '', isAdmin: false),
      UserEntity(id: "5", name: "Hoang Thi D", email: '', isAdmin: false),
      UserEntity(id: "6", name: "Vu Van E", email: '', isAdmin: false),
      UserEntity(id: "7", name: "Pham Thi F", email: '', isAdmin: false),
      UserEntity(id: "8", name: "Nguyen Van G", email: '', isAdmin: false),
      UserEntity(id: "9", name: "Le Thi H", email: '', isAdmin: false),
      UserEntity(id: "10", name: "Tran Van I", email: '', isAdmin: false),
      UserEntity(id: "11", name: "Hoang Thi K", email: '', isAdmin: false),
      UserEntity(id: "12", name: "Vu Van L", email: '', isAdmin: false),
      UserEntity(id: "13", name: "Pham Thi M", email: '', isAdmin: false),
      UserEntity(id: "14", name: "Nguyen Van N", email: '', isAdmin: false),
      UserEntity(id: "15", name: "Le Thi O", email: '', isAdmin: false),
      UserEntity(id: "16", name: "Tran Van P", email: '', isAdmin: false),
      UserEntity(id: "17", name: "Hoang Thi Q", email: '', isAdmin: false),
      UserEntity(id: "18", name: "Vu Van R", email: '', isAdmin: false),
    ]);
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
  Future<PagedResult<UserEntity>> getUserInGroup({
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

  @override
  Future<PagedResult<MediaEntity>> getMediasInGroup({
    required int workspaceId,
    required int offset,
    required int limit,
  }) async {
    try {
      return PagedResult(
        data: MockData().mockMediaData.sublist(offset, offset + limit),
        totalRecords: MockData().mockMediaData.length,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<PagedResult<FileEntity>> getFileInGroup({
    required int workspaceId,
    required int offset,
    required int limit,
  }) async {
    try {
      return PagedResult(
        data: MockData().mockFileEntities().sublist(offset, offset + limit),
        totalRecords: MockData().mockFileEntities().length,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<PagedResult<String>> getLinkInGroup({
    required int workspaceId,
    required int offset,
    required int limit,
  }) async {
    try {
      return PagedResult(
        data: MockData().mockLinks,
        totalRecords: MockData().mockLinks.length,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
