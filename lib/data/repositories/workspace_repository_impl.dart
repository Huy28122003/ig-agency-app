import 'package:ig_agency_app/data/remote/models/requests/get_workspaces_request_model.dart';
import 'package:ig_agency_app/data/remote/translators/workspace_translator.dart';
import 'package:ig_agency_app/domain/entities/file_entity.dart';
import 'package:ig_agency_app/domain/entities/media_entity.dart';
import 'package:ig_agency_app/domain/entities/user_entity.dart';
import 'package:ig_agency_app/domain/entities/workspace_entity.dart';
import 'package:ig_agency_app/shared/commons/models/pagination.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../../shared/commons/failure_converter.dart';
import '../../shared/utils/mock_data.dart';
import '../app/workspace_remote_data_source.dart';

@Injectable(as: GroupRepository)
class Group implements GroupRepository {
  final WorkspaceRemoteDataSource _workspaceRemoteDataSource;

  Group(this._workspaceRemoteDataSource);

  @override
  Future<List<GroupEntity>> getWorkspaces({
    required int limit,
    required int offset,
    String? keyWord,
  }) async {
    try {
      final response = await _workspaceRemoteDataSource.getWorkspaces(
        getWorkspacesRequest: GetWorkspacesRequestModel(
          limit: limit,
          offset: offset,
          search: keyWord,
        ),
      );
      return response.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Stream<GroupEntity> listenLastMessages() {
    // TODO: implement listenLastMessages
    throw UnimplementedError();
  }

  @override
  Future<GroupEntity> getWorkspaceById({required String groupId}) async {
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
    required String groupId,
    required String bio,
  }) async {
    try {
      return true;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<bool> updateWorkspaceName({
    required int groupId,
    required String name,
  }) async {
    try {
      return true;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<bool> updateWorkspaceNotification({
    required String groupId,
    required bool isMute,
  }) async {
    try {
      return true;
    } catch (e) {
      throw FailureConverter.convert(e);
    }
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
      UserEntity(id: "1", name: "Pham Phu", isAdmin: false),
      UserEntity(id: "2", name: "Nguyen Van A", isAdmin: false),
      UserEntity(id: "3", name: "Le Thi B", isAdmin: false),
      UserEntity(id: "4", name: "Tran Van C", isAdmin: false),
      UserEntity(id: "5", name: "Hoang Thi D", isAdmin: false),
      UserEntity(id: "6", name: "Vu Van E", isAdmin: false),
      UserEntity(id: "7", name: "Pham Thi F", isAdmin: false),
      UserEntity(id: "8", name: "Nguyen Van G", isAdmin: false),
      UserEntity(id: "9", name: "Le Thi H", isAdmin: false),
      UserEntity(id: "10", name: "Tran Van I", isAdmin: false),
      UserEntity(id: "11", name: "Hoang Thi K", isAdmin: false),
      UserEntity(id: "12", name: "Vu Van L", isAdmin: false),
      UserEntity(id: "13", name: "Pham Thi M", isAdmin: false),
      UserEntity(id: "14", name: "Nguyen Van N", isAdmin: false),
      UserEntity(id: "15", name: "Le Thi O", isAdmin: false),
      UserEntity(id: "16", name: "Tran Van P", isAdmin: false),
      UserEntity(id: "17", name: "Hoang Thi Q", isAdmin: false),
      UserEntity(id: "18", name: "Vu Van R", isAdmin: false),
    ]);
  }

  @override
  Future<bool> addUserToGroups(UserEntity user, List<GroupEntity> groups) {
    return Future.value(true);
  }

  @override
  Future<List<GroupEntity>> getListGroup({
    required Pagination pagination,
    String? keySearch,
  }) {
    try {
      final allData = MockData.getWorkspaces();

      final filtered = keySearch != null && keySearch.isNotEmpty
          ? allData
                .where(
                  (e) => e.groupName.toLowerCase().contains(
                    keySearch.toLowerCase(),
                  ),
                )
                .toList()
          : allData;

      return Future.value(filtered);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<UserEntity>> getUserInGroup({
    required String workspaceId,
    required int offset,
    required int limit,
  }) async {
    try {
      return MockData().users.sublist(
        offset,
        offset + limit > MockData().users.length
            ? MockData().users.length
            : offset + limit,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<MediaEntity>> getMediasInGroup({
    required String workspaceId,
    required int offset,
    required int limit,
  }) async {
    try {
      return MockData().mockMediaData.sublist(
        offset,
        offset + limit > MockData().mockMediaData.length
            ? MockData().mockMediaData.length
            : offset + limit,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<FileEntity>> getFileInGroup({
    required String workspaceId,
    required int offset,
    required int limit,
  }) async {
    try {
      return MockData().mockFileEntities().sublist(
        offset,
        offset + limit > MockData().mockFileEntities().length
            ? MockData().mockFileEntities().length
            : offset + limit,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<List<String>> getLinkInGroup({
    required String workspaceId,
    required int offset,
    required int limit,
  }) async {
    try {
      return MockData().mockLinks.sublist(
        offset,
        offset + limit > MockData().mockLinks.length
            ? MockData().mockLinks.length
            : offset + limit,
      );
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> pinWorkspace(String workspaceId) async {
    try {
      await _workspaceRemoteDataSource.pinWorkspace(workspaceId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> unpinWorkspace(String workspaceId) async {
    try {
      await _workspaceRemoteDataSource.unpinWorkspace(workspaceId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }

  @override
  Future<void> deleteWorkspace(String workspaceId) async {
    try {
      await _workspaceRemoteDataSource.deleteGroup(workspaceId);
    } catch (e) {
      throw FailureConverter.convert(e);
    }
  }
}
