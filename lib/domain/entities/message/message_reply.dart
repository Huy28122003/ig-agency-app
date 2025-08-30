import '../../enums/message_enums.dart';

class MessageReply {
  final String messageId;
  final String senderName;
  final String? previewText;
  final String? previewImageUrl;
  final String? previewThumbnailUrl;
  final String? previewAudioName;
  final String? previewFileName;
  final MessageType? originalMessageType;

  MessageReply({
    required this.messageId,
    required this.senderName,
    this.previewText,
    this.previewImageUrl,
    this.previewThumbnailUrl,
    this.previewAudioName,
    this.previewFileName,
    this.originalMessageType,
  });

  MessageReply copyWith({
    String? previewText,
    String? previewImageUrl,
    String? previewThumbnailUrl,
    String? previewAudioName,
    String? previewFileName,
  }) => MessageReply(
    messageId: messageId,
    senderName: senderName,
    previewText: previewText,
    previewImageUrl: previewImageUrl,
    previewThumbnailUrl: previewThumbnailUrl,
    previewAudioName: previewAudioName,
    previewFileName: previewFileName,
    originalMessageType: originalMessageType,
  );
}
