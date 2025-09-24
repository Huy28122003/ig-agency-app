import 'package:ig_agency_app/data/remote/models/requests/get_workspaces_request_model.dart';

import 'package:ig_agency_app/data/remote/models/response/get_workspaces_response_model.dart';

import 'package:ig_agency_app/data/remote/models/response/paged_response.dart';

import '../../../shared/commons/exception_converter.dart';
import '../app/workspace_remote_data_source.dart';
import '../services/api_services.dart';

class WorkspaceRemoteDataSourceImpl extends WorkspaceRemoteDataSource {
  final ApiService _apiService;

  WorkspaceRemoteDataSourceImpl(this._apiService);
  @override
  Future<PagedResponse<GetWorkspacesResponseModel>> getWorkspaces({
    required GetWorkspacesRequestModel getWorkspacesRequest,
  }) async {
    try {
      return await _apiService.getWorkspaces(getWorkspacesRequest);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
