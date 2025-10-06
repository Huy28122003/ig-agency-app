import 'package:ig_agency_app/data/remote/models/response/group_detail_response_model.dart';

abstract class GroupRemoteDataSource {
  Future<GroupDetailResponseModel> getGroupDetail(String conversationId);
}
