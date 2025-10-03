import 'package:ig_agency_app/data/remote/models/requests/get_data_in_group_request.dart';
import 'package:ig_agency_app/data/remote/models/requests/get_workspaces_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/get_workspaces_response_model.dart';
import 'package:ig_agency_app/data/remote/models/response/user_profile_response_model.dart';

abstract class GroupRemoteDataSource {
  Future<List<GroupResponse>> getWorkspaces({
    required GetWorkspacesRequestModel getWorkspacesRequest,
  });

  Future<void> pinWorkspace(String groupId);

  Future<void> unpinWorkspace(String groupId);

  Future<void> deleteGroup(String groupId);

  Future<GroupResponse> getGroupInfo(String groupId);

  Future<List<UserProfileResponseModel>> getUserInGroup(
    GetDataInGroupRequest request,
  );
}
