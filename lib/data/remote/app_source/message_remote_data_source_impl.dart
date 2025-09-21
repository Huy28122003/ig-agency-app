import 'package:ig_agency_app/data/remote/app/message_remote_data_source.dart';
import 'package:ig_agency_app/domain/entities/message/message.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/commons/exception_converter.dart';
import '../models/requests/send_message_request_model.dart';
import '../services/api_services.dart';
import '../services/mock/message_mock_service.dart';

@Injectable(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  MessageRemoteDataSourceImpl(this._messageMockService, this._apiService);

  final MessageMockService _messageMockService;
  final ApiService _apiService;

  @override
  Future<List<MessageEntity>> fetchPinnedMessage(int limit, int offset) async {
    try {
      final pinnedMessages = _messageMockService.mockFetchPinnedMessages(
        limit: limit,
        offset: offset,
      );

      return pinnedMessages;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> unpinMessage(String messageId) async {
    try {
      await _messageMockService.mockUnpinMessage(messageId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> sendMessage(
    String userId,
    String groupId,
    String? replyMessageId,
    MessageContent content,
  ) async {
    try {
      if (content is TextMessageContent) {
        await _apiService.sendMessage(
          groupId,
          SendMessageRequestModel(
            type: content.messageContentType.name,
            text: content.text,
            replyToMessageId: replyMessageId,
          ),
        );
      } else {
        throw Exception('Unsupported content type');
      }
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
