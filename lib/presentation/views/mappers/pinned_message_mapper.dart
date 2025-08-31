import '../../../domain/entities/message/message.dart';
import '../../../domain/enums/message_enums.dart';
import '../../../shared/commons/enums/pinned_message_type.dart';
import '../models/pinned_message_ui_model.dart';

class PinnedMessageMapper {
  static PinnedMessageUIModel fromMessageEntity(MessageEntity entity) {
    return PinnedMessageUIModel(
      id: entity.id,
      senderName: entity.sender.name,
      senderAvatarUrl: entity.sender.avatarUrl,
      pinnedAt: entity.pinnedAt ?? DateTime.now(),
      type: switch (entity.type) {
        MessageType.image => PinnedMessageType.image,
        MessageType.video => PinnedMessageType.video,
        MessageType.file => PinnedMessageType.file,
        _ => PinnedMessageType.text,
      },
      content: entity.content,
    );
  }
}
