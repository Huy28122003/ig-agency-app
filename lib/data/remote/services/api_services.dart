import 'package:dio/dio.dart';
import 'package:ig_agency_app/data/remote/models/requests/login_request_model.dart';
import 'package:retrofit/retrofit.dart';

import '../models/response/login_response_model.dart';

part 'api_services.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST('/login')
  Future<LoginResponseModel> login(@Body() LoginRequestModel loginRequestModel);
}
