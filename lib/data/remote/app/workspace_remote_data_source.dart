import 'package:ig_agency_app/data/remote/models/requests/get_workspaces_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/get_workspaces_response_model.dart';

import '../models/response/paged_response.dart';

abstract class WorkspaceRemoteDataSource {
  Future<PagedResponse<GetWorkspacesResponseModel>> getWorkspaces({
    required GetWorkspacesRequestModel getWorkspacesRequest,
  });
}
