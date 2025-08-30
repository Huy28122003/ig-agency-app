import 'package:ig_agency_app/data/remote/app/message_remote_data_source.dart';
import 'package:ig_agency_app/domain/entities/message/message.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/commons/exception_converter.dart';
import '../services/mock/message_mock_service.dart';

@Injectable(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  MessageRemoteDataSourceImpl(this._messageMockService);

  final MessageMockService _messageMockService;

  @override
  Future<List<MessageEntity>> getPinnedMessages(int limit, int offset) async {
    try {
      final List<MessageEntity> pinnedMessages = _messageMockService
          .mockPinnedMessages(limit: limit, offset: offset);

      return pinnedMessages;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
