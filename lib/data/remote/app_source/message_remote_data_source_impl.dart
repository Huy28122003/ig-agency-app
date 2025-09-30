import 'package:ig_agency_app/data/remote/app/message_remote_data_source.dart';
import 'package:ig_agency_app/data/remote/models/requests/pin_message_request_model.dart';
import 'package:ig_agency_app/data/remote/services/api_services.dart';
import 'package:ig_agency_app/data/remote/translators/message_translator.dart';
import 'package:ig_agency_app/domain/entities/message/message.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/commons/exception_converter.dart';

@Injectable(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  MessageRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<List<MessageEntity>> fetchPinnedMessage(
    String groupId,
    int limit,
    int offset,
  ) async {
    try {
      final pinnedMessages = await _apiService.getPinnedMessages(
        groupId,
        limit,
        offset,
        null,
        null,
      );

      return pinnedMessages.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> unpinMessage(String groupId, String messageId) async {
    try {
      await _apiService.unpinMessage(groupId, messageId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> pinMessage(String groupId, String messageId) async {
    try {
      await _apiService.pinMessage(
        groupId,
        PinMessageRequestModel(messageId: messageId),
      );
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
