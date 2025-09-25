import 'package:ig_agency_app/data/remote/models/requests/get_workspaces_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/get_workspaces_response_model.dart';

abstract class WorkspaceRemoteDataSource {
  Future<List<GetWorkspacesResponseModel>> getWorkspaces({
    required GetWorkspacesRequestModel getWorkspacesRequest,
  });

  Future<void> pinWorkspace(String groupId);

  Future<void> unpinWorkspace(String groupId);

  Future<void> deleteGroup(String groupId);
}
