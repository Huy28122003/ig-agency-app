import 'package:ig_agency_app/data/remote/models/response/group_summary_response.dart';
import 'package:ig_agency_app/domain/entities/group_summary.dart';
import 'package:ig_agency_app/shared/extensions/date_time_extension.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';
import '../../../domain/enums/message_enums.dart';

extension GroupSummaryTranslator on GroupSummaryResponse {
  GroupSummary toEntity() {
    final messageType = MessageContentType.fromCode(lastMessage?.type ?? '');

    final lastMessageTime = lastMessageDate?.toLocalTime(isSecond: true);

    final lastMessageContent = lastMessage == null
        ? ''
        : _mapLastMessageContent(messageType, lastMessage?.text);
    return GroupSummary(
      id: id,
      name: title,
      // avatar: photo?.bigFilePath.withBaseUrl() ?? '',
      avatar: photo?.withBaseUrl() ?? '',
      lastMessage: lastMessageContent,
      lastMessageTime: lastMessageTime,
      isPin: pinned,
      isSeen: isRead,
      isMute: notificationEnabled,
      unReadCount: unreadCount,
    );
  }

  String _mapLastMessageContent(MessageContentType type, String? text) {
    if (type == MessageContentType.text) {
      return text ?? '';
    }
    return type.title;
  }
}
