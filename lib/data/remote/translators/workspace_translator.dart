import 'package:ig_agency_app/data/remote/models/response/get_workspaces_response_model.dart';
import 'package:ig_agency_app/domain/enums/message_enums.dart';

import '../../../domain/entities/workspace_entity.dart';

extension WorkspaceTranslator on GetWorkspacesResponseModel {
  WorkspaceEntity toEntity() {
    final lastMsg = lastMessage;
    final messageType = MessageContentType.fromString(lastMsg?.type ?? '');

    final lastMessageTime = lastMessageDate == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(lastMessageDate!);

    final lastMessageContent = lastMsg == null
        ? ''
        : _mapLastMessageContent(messageType, lastMsg.text);

    return WorkspaceEntity(
      id: id,
      workspaceName: title,
      lastMessage: lastMessageContent,
      lastMessageTime: lastMessageTime,
      isPin: pinned,
      //todo
      workspaceAvatar: "https://i.pravatar.cc/150?img=1",
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
