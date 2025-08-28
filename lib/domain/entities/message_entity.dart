import '../enums/message_enums.dart';

class MessageEntity {
  MessageEntity({
    this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.createdAt,
    required this.type,
    required this.content,
    required this.status,
    this.groupId,
    this.groupName,
    this.replyToMessageId,
    this.replyInfo,
    this.isPinned = false,
    this.pinnedAt,
  });

  final String? id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final DateTime createdAt;
  final MessageType type;
  final MessageContent content;
  final MessageStatus status;
  final String? groupId;
  final String? groupName;
  final String? replyToMessageId;
  final MessageReplyInfo? replyInfo;
  final bool isPinned;
  final DateTime? pinnedAt;
}

class MessageContent {
  // Text message
  const MessageContent.text({required String text});

  // Image message
  const MessageContent.image({
    required String imageUrl,
    int? width,
    int? height,
  });

  // Audio message
  const MessageContent.audio({
    required String audioUrl,
    required Duration duration,
    required int fileSize,
    String? waveform, // Base64 encoded waveform data
  });

  // File message
  const MessageContent.file({
    required String fileUrl,
    required String fileName,
    required String fileExtension,
    required int fileSize,
    FileType? fileType,
  });

  // Link message (preview card)
  const MessageContent.link({
    required String url,
    required String title,
    String? description,
    String? domain,
  });

  // System message
  const MessageContent.system({
    required SystemMessageType systemType,
    String? message,
  });
}

class MessageReplyInfo {
  final String messageId;
  final String senderName;
  final String previewText;
  final MessageType? originalMessageType;

  MessageReplyInfo({
    required this.messageId,
    required this.senderName,
    required this.previewText,
    this.originalMessageType,
  });
}
