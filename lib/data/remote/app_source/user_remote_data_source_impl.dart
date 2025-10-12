import 'package:dio/dio.dart';
import 'package:ig_agency_app/data/remote/models/response/profile_info_response.dart';
import 'package:ig_agency_app/data/remote/services/api_services.dart';
import 'package:injectable/injectable.dart';
import '../../../shared/commons/exception_converter.dart';
import '../app/user_remote_data_source.dart';
import '../models/requests/update_profile_request_model.dart';

@Injectable(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiService _apiService;

  UserRemoteDataSourceImpl(this._apiService);

  @override
  Future<ProfileInfoResponse> getProfileInfo() async {
    try {
      return await _apiService.getProfileInfo();
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<ProfileInfoResponse> updateName(String name) async {
    try {
      final response = await _apiService.updateName(
        UpdateProfileRequestModel(name: name),
      );
      return response;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<ProfileInfoResponse> updateBio(String bio) async {
    try {
      final response = await _apiService.updateBio(
        UpdateProfileRequestModel(bio: bio),
      );
      return response;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<ProfileInfoResponse> updateAvatar(MultipartFile avatar) async {
    try {
      final response = await _apiService.updateAvatar(avatar);
      return response;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
