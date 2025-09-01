import '../../../domain/entities/message.dart';
import '../models/response/message_summary_response.dart';

extension MessageSummaryTranslator on MessageSummaryResponse {
  MessageSummary toEntity() {
    return MessageSummary(id: id, message: message);
  }
}
