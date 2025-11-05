import 'package:ig_agency_app/data/remote/models/response/group_response.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';

import '../../../domain/entities/group_info_entity.dart';

extension GroupTranslator on GroupResponse {
  GroupInfoEntity toEntity() {
    // final lastMsg = lastMessage;
    // final messageType = MessageContentType.fromCode(lastMsg?.type ?? '');
    //
    // final lastMessageTime = lastMessageDate == null
    //     ? null
    //     : DateTime.fromMillisecondsSinceEpoch(lastMessageDate!);
    //
    // final lastMessageContent = lastMsg == null
    //     ? ''
    //     : _mapLastMessageContent(messageType, lastMsg.text);

    return GroupInfoEntity(
      id: id,
      groupName: title,
      // lastMessage: lastMessageContent,
      // lastMessageTime: lastMessageTime,
      // isPin: pinned,
      //todo
      groupAvatar: photo?.withBaseUrl() ?? '',
      // groupAvatar: photo?.bigFilePath.withBaseUrl() ?? '',
      // isSeen: true,
      isMute: true,
      countPin: pinnedMessageCount,
      countMember: memberCount,
      bio: bio ?? '',
    );
  }

  // String _mapLastMessageContent(MessageContentType type, String? text) {
  //   if (type == MessageContentType.text) {
  //     return text ?? '';
  //   }
  //   return type.title;
  // }
}
