import 'package:ig_agency_app/data/remote/models/requests/get_workspaces_request_model.dart';

import 'package:ig_agency_app/data/remote/models/response/group_response.dart';

import 'package:injectable/injectable.dart';

import '../../../shared/commons/exception_converter.dart';
import '../app/workspace_remote_data_source.dart';
import '../services/api_services.dart';

@Injectable(as: GroupRemoteDataSource)
class GroupRemoteDataSourceImpl extends GroupRemoteDataSource {
  final ApiService _apiService;

  GroupRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<GroupResponse>> getWorkspaces({
    required GetWorkspacesRequestModel getWorkspacesRequest,
  }) async {
    try {
      return await _apiService.getGroups(getWorkspacesRequest);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> pinWorkspace(String groupId) async {
    try {
      return await _apiService.pinGroup(groupId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> unpinWorkspace(String groupId) async {
    try {
      return await _apiService.unpinGroup(groupId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    try {
      return await _apiService.deleteGroup(groupId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
