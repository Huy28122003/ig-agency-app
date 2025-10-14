import 'package:ig_agency_app/data/remote/models/response/group_summary_response.dart';
import 'package:ig_agency_app/domain/entities/group_summary.dart';
import 'package:ig_agency_app/flavor_settings.dart';

import '../../../domain/enums/message_enums.dart';

extension GroupSummaryTranslator on GroupSummaryResponse {
  GroupSummary toEntity() {
    final messageType = MessageContentType.fromCode(lastMessage?.type ?? '');

    final lastMessageTime = lastMessageDate == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(lastMessageDate! * 1000);

    final lastMessageContent = lastMessage == null
        ? ''
        : _mapLastMessageContent(messageType, lastMessage?.text);
    return GroupSummary(
      id: id,
      name: title,
      avatar:
          "${FlavorEnvironment.development.baseUrl}/${photo?.bigFilePath ?? ''}",
      lastMessage: lastMessageContent,
      lastMessageTime: lastMessageTime,
      isPin: pinned,
      isSeen: true,
      isMute: true,
    );
  }

  String _mapLastMessageContent(MessageContentType type, String? text) {
    if (type == MessageContentType.text) {
      return text ?? '';
    }
    return type.value;
  }
}
