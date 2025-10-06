import 'package:ig_agency_app/data/remote/app/member_remote_data_source.dart';
import 'package:ig_agency_app/data/remote/models/response/member_response_model.dart';
import 'package:ig_agency_app/data/remote/services/api_services.dart';
import 'package:ig_agency_app/shared/commons/exception_converter.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MemberRemoteDataSource)
class MemberRemoteDataSourceImpl implements MemberRemoteDataSource {
  MemberRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<List<MemberResponseModel>> fetchMembersInGroup({
    required String groupId,
  }) async {
    try {
      final members = await _apiService.getMembersInGroup(groupId);
      return members;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<List<MemberResponseModel>> searchMembersInGroup({
    required String groupId,
    required String query,
  }) async {
    try {
      final members = await _apiService.searchMembersInGroup(groupId, query);
      return members;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
