import 'package:ig_agency_app/data/remote/app/group_remote_data_source.dart';
import 'package:ig_agency_app/data/remote/models/response/group_detail_response_model.dart';
import 'package:ig_agency_app/data/remote/services/api_services.dart';
import 'package:ig_agency_app/shared/commons/exception_converter.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GroupRemoteDataSource)
class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  GroupRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<GroupDetailResponseModel> getGroupDetail(String conversationId) async {
    try {
      final groupDetail = await _apiService.getGroupDetail(conversationId);
      return groupDetail;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
