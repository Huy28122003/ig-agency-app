import 'package:ig_agency_app/data/remote/app/message_remote_data_source.dart';
import 'package:ig_agency_app/domain/entities/message_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/commons/exception_converter.dart';
import '../../../shared/mock/mock_data_pinned_messages.dart';

@Injectable(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  @override
  Future<List<MessageEntity>> getPinnedMessages(int limit, int offset) async {
    try {
      final List<MessageEntity> mockData =
          MockDataPinnedMessages.getMockPinnedMessages();

      if (mockData.isEmpty || offset >= mockData.length) {
        return [];
      }

      // Xử lý limit và offset
      final List<MessageEntity> pinnedMessages = mockData
          .skip(offset)
          .take(limit)
          .toList();

      return pinnedMessages;
    } catch (e) {
      throw ExceptionConverter.convert(e);
    }
  }
}
