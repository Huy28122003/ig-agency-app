import 'package:dio/dio.dart';
import 'package:ig_agency_app/data/remote/models/requests/login_request_model.dart';
import 'package:retrofit/retrofit.dart';

import '../models/requests/registration_request_model.dart';
import '../models/requests/change_password_request_model.dart';
import '../models/response/login_response_model.dart';
import '../models/response/registration_reponse_model.dart';
import '../models/response/change_password_response_model.dart';

part 'api_services.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST('/login')
  Future<LoginResponseModel> login(@Body() LoginRequestModel loginRequestModel);

  @POST('/register')
  Future<RegistrationResponseModel> register(
    @Body() RegistrationRequestModel registrationRequestModel,
  );

  @POST('/change-password')
  Future<ChangePasswordResponseModel> changePassword(
    @Body() ChangePasswordRequestModel changePasswordRequestModel,
  );
}
