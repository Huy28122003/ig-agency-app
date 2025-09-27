import 'package:ig_agency_app/data/remote/app/message_remote_data_source.dart';
import 'package:ig_agency_app/data/remote/models/requests/pin_message_request_model.dart';
import 'package:ig_agency_app/data/remote/translators/message_translator.dart';
import 'package:ig_agency_app/domain/entities/message/message.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/commons/exception_converter.dart';
import '../models/requests/send_message_request_model.dart';
import '../services/api_services.dart';

@Injectable(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  MessageRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<List<MessageEntity>> fetchPinnedMessage(
    String groupId,
    int limit,
    int offset,
    String? search,
    String? before,
  ) async {
    try {
      final pinnedMessages = await _apiService.getPinnedMessages(
        groupId,
        limit,
        offset,
        search,
        before,
      );

      return pinnedMessages.map((e) => e.toEntity()).toList();
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

  @override
  Future<void> unpinMessage(String groupId, String messageId) async {
    try {
      await _apiService.unpinMessage(groupId, messageId);
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
            type: 'text',
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

  @override
  Future<List<MessageEntity>> fetchMessagesInGroup(
    String groupId,
    int limit,
    String? beforeMessageId,
    String? targetMessageId,
  ) async {
    final messages = await _apiService.getMessages(
      groupId,
      limit,
      0,
      null,
      beforeMessageId,
    );

    return messages.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> deleteMessageForEveryone(
    String groupId,
    String messageId,
  ) async {
    try {
      await _apiService.deleteMessage(groupId, messageId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }

  @override
  Future<void> deleteMessageForYou(String groupId, String messageId) async {
    try {
      await _apiService.deleteMessage(groupId, messageId);
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
