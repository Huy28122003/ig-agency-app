import 'package:dio/dio.dart';
import 'package:ig_agency_app/data/remote/models/requests/forgot_password_request_model.dart';
import 'package:ig_agency_app/data/remote/models/requests/login_request_model.dart';
import 'package:ig_agency_app/data/remote/models/requests/logout_request_model.dart';
import 'package:ig_agency_app/data/remote/models/requests/search_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/forgot_password_response_model.dart';
import 'package:ig_agency_app/data/remote/models/response/paged_response.dart';
import 'package:ig_agency_app/data/remote/models/response/search_result_response.dart';
import 'package:retrofit/retrofit.dart';

import '../models/requests/registration_request_model.dart';
import '../models/requests/change_password_request_model.dart';
import '../models/response/login_response_model.dart';
import '../models/response/profile_info_response.dart';

part 'api_services.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  //authen
  @POST('/login')
  Future<LoginResponseModel> login(@Body() LoginRequestModel loginRequestModel);

  @POST('/logout')
  Future logout(@Body() LogoutRequestModel logoutRequestModel);

  @POST('/register')
  Future register(@Body() RegistrationRequestModel requestModel);

  @PUT('/password')
  Future<void> changePassword(@Body() ChangePasswordRequestModel requestModel);

  @POST('/forgot-password')
  Future<ForgotPasswordResponseModel> forgotPassword(
    @Body() ForgotPasswordRequestModel forgotPasswordRequestModel,
  );

  @POST('/reset-password')
  Future resetPassword(
    @Body() ForgotPasswordRequestModel forgotPasswordRequestModel,
  );

  // Profile
  @GET('/profile')
  Future<ProfileInfoResponse> getProfileInfo();

  //Search
  @POST('/')
  Future<PagedResponse<SearchResultResponse>> search(
    @Body() SearchRequestModel request,
  );

  @MultiPart()
  @PUT('/profile')
  Future<ProfileInfoResponse> updateProfile({
    @Part(name: "name") String? name,
    @Part(name: "bio") String? bio,
    @Part(name: "avatar") MultipartFile? avatar,
  });
}
