import '../../enums/message_enums.dart';

class MessageReply {
  final String messageId;
  final String senderName;
  final String? previewText;
  final String? previewImageUrl;
  final String? previewThumbnailUrl;
  final String? previewAudioName;
  final String? previewFileName;
  final double? previewWidth; // for image and video
  final double? previewHeight; // for image and video
  final MessageType? originalMessageType;

  MessageReply({
    required this.messageId,
    required this.senderName,
    this.previewText,
    this.previewImageUrl,
    this.previewThumbnailUrl,
    this.previewAudioName,
    this.previewFileName,
    this.previewWidth,
    this.previewHeight,
    this.originalMessageType,
  });

  MessageReply copyWith({
    String? previewText,
    String? previewImageUrl,
    String? previewThumbnailUrl,
    String? previewAudioName,
    String? previewFileName,
    double? previewWidth,
    double? previewHeight,
  }) => MessageReply(
    messageId: messageId,
    senderName: senderName,
    previewText: previewText,
    previewImageUrl: previewImageUrl,
    previewThumbnailUrl: previewThumbnailUrl,
    previewAudioName: previewAudioName,
    previewFileName: previewFileName,
    originalMessageType: originalMessageType,
    previewWidth: previewWidth ?? this.previewWidth,
    previewHeight: previewHeight ?? this.previewHeight,
  );
}
