import '../../enums/message_enums.dart';
import 'message_content.dart';
import 'message_reply.dart';
import 'message_sender.dart';

class MessageEntity {
  MessageEntity({
    this.id,
    required this.sender,
    required this.createdAt,
    required this.type,
    required this.content,
    required this.status,
    this.groupId,
    this.groupName,
    this.reply,
    this.isPinned = false,
    this.pinnedAt,
  });

  bool get isText => type == MessageType.text && content is TextMessageContent;

  bool get isImage =>
      type == MessageType.image && content is ImageMessageContent;

  bool get isVideo =>
      type == MessageType.video && content is VideoMessageContent;

  bool get isFile => type == MessageType.file && content is FileMessageContent;

  bool get isSystem =>
      type == MessageType.system && content is SystemMessageContent;

  final String? id;
  final MessageSender sender;
  final DateTime createdAt;
  final MessageType type;
  final MessageContent content;
  final MessageStatus status;
  final int? groupId;
  final String? groupName;
  final MessageReply? reply;
  final bool isPinned;
  final DateTime? pinnedAt;
}
