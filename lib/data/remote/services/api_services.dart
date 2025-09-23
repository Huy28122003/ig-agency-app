import 'package:dio/dio.dart';
import 'package:ig_agency_app/data/remote/models/requests/login_request_model.dart';
import 'package:ig_agency_app/data/remote/models/requests/search_request_model.dart';
import 'package:ig_agency_app/data/remote/models/response/message_response_model.dart';
import 'package:ig_agency_app/data/remote/models/response/paged_response.dart';
import 'package:ig_agency_app/data/remote/models/response/search_result_response.dart';
import 'package:retrofit/retrofit.dart';

import '../models/requests/pin_message_request_model.dart';
import '../models/requests/registration_request_model.dart';
import '../models/requests/change_password_request_model.dart';
import '../models/requests/send_message_request_model.dart';
import '../models/response/login_response_model.dart';
import '../models/response/change_password_response_model.dart';
import '../models/response/profile_info_response.dart';

part 'api_services.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST('/login')
  Future<LoginResponseModel> login(@Body() LoginRequestModel loginRequestModel);

  @POST('/register')
  Future register(@Body() RegistrationRequestModel requestModel);

  @POST('/change-password')
  Future<ChangePasswordResponseModel> changePassword(
    @Body() ChangePasswordRequestModel requestModel,
  );

  // Profile
  @GET('/profile')
  Future<ProfileInfoResponse> getProfileInfo();

  //Search
  @POST('/')
  Future<PagedResponse<SearchResultResponse>> search(
    @Body() SearchRequestModel request,
  );

  // Conversation
  @DELETE('/conversations/{conversationId}')
  Future<void> deleteConversation(
    @Path('conversationId') String conversationId,
  );

  @GET('/conversations/{conversationId}/messages')
  Future<List<MessageResponseModel>> getMessages(
    @Path('conversationId') String conversationId,
    @Query('limit') int limit,
    @Query('offset') int offset,
    @Query('search') String? search,
    @Query('before') String? beforeMessageId,
  );

  @POST('/conversations/{conversationId}/messages')
  Future<void> sendMessage(
    @Path('conversationId') String conversationId,
    @Body() SendMessageRequestModel request,
  );

  @DELETE('/conversations/{conversationId}/messages/{messageId}')
  Future<void> deleteMessage(
    @Path('conversationId') String conversationId,
    @Path('messageId') String messageId,
  );

  // @GET('/conversations/{conversationId}/pinned-messages')
  // Future<List<void>> getPinnedMessages(
  //   @Path('conversationId') String conversationId,
  //   @Query('limit') int limit,
  //   @Query('offset') int offset,
  //   @Query('search') String? search,
  //   @Query('before') String? beforeMessageId,
  // );

  @POST('/conversations/{conversationId}/pinned-messages')
  Future<void> pinMessage(
    @Path('conversationId') String conversationId,
    @Body() PinMessageRequestModel request,
  );

  @DELETE('/conversations/{conversationId}/pinned-messages/{messageId}')
  Future<void> unpinMessage(
    @Path('conversationId') String conversationId,
    @Path('messageId') String messageId,
  );

  // @GET('/conversations/{conversationId}/members')
  // Future<List<void>> getMembers(
  //   @Path('conversationId') String conversationId,
  //   @Query('limit') int limit,
  //   @Query('offset') int offset,
  // );
}
