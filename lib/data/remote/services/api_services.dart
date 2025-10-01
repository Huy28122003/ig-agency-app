import 'package:dio/dio.dart';
import 'package:ig_agency_app/data/remote/models/requests/login_request_model.dart';
import 'package:ig_agency_app/data/remote/models/requests/search_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/paged_response.dart';
import 'package:ig_agency_app/data/remote/models/response/search_result_response.dart';
import 'package:retrofit/retrofit.dart';

import '../models/requests/registration_request_model.dart';
import '../models/requests/change_password_request_model.dart';
import '../models/requests/update_profile_request_model.dart';
import '../models/response/login_response_model.dart';
import '../models/response/profile_info_response.dart';

part 'api_services.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST('/login')
  Future<LoginResponseModel> login(@Body() LoginRequestModel loginRequestModel);

  @POST('/register')
  Future register(@Body() RegistrationRequestModel requestModel);

  @PUT('/password')
  Future<void> changePassword(@Body() ChangePasswordRequestModel requestModel);

  // Profile
  @GET('/profile')
  Future<ProfileInfoResponse> getProfileInfo();

  //Search
  @POST('/')
  Future<PagedResponse<SearchResultResponse>> search(
    @Body() SearchRequestModel request,
  );

  @PUT('/profile')
  Future<ProfileInfoResponse> updateProfile(
    @Body() UpdateProfileRequestModel request,
  );
}
