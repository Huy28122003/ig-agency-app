import 'package:ig_agency_app/data/remote/models/requests/get_workspaces_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/group_response.dart';

abstract class GroupRemoteDataSource {
  Future<List<GroupResponse>> getWorkspaces({
    required GetWorkspacesRequestModel getWorkspacesRequest,
  });

  Future<void> pinWorkspace(String groupId);

  Future<void> unpinWorkspace(String groupId);

  Future<void> deleteGroup(String groupId);
}
