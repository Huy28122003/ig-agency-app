import 'package:ig_agency_app/data/remote/models/response/profile_info_response.dart';
import 'package:ig_agency_app/data/remote/services/api_services.dart';
import 'package:ig_agency_app/data/remote/translators/profile_info_translator.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/user/profile_info_entity.dart';
import '../../../shared/commons/exception_converter.dart';
import '../app/user_remote_data_source.dart';
import 'package:ig_agency_app/data/remote/models/requests/update_profile_request_model.dart';

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
  Future<ProfileInfoEntity> updateProfile({
    String? name,
    String? bio,
    String? avatar,
  }) async {
    try {
      final response = await _apiService.updateProfile(
        UpdateProfileRequestModel(name: name, bio: bio, avatar: avatar),
      );
      return response.toEntity();
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
