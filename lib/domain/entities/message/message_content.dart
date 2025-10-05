import '../../enums/message_enums.dart';
import 'text_segment.dart';

sealed class MessageContent {
  const MessageContent({required this.messageContentType});

  final MessageContentType messageContentType;

  bool get isText => messageContentType == MessageContentType.text;
  bool get isImage => messageContentType == MessageContentType.photo;
  bool get isVideo => messageContentType == MessageContentType.video;
  bool get isFile => messageContentType == MessageContentType.document;
  bool get isSystem => messageContentType == MessageContentType.system;
  bool get isSticker => messageContentType == MessageContentType.sticker;
  bool get isNotSystem => messageContentType != MessageContentType.system;
}

class TextMessageContent extends MessageContent {
  final String text;
  final List<TextSegment>? textSegments;
  const TextMessageContent({required this.text, this.textSegments})
      : super(messageContentType: MessageContentType.text);
}

class ImageMessageContent extends MessageContent {
  final String imageUrl;
  final double? width;
  final double? height;
  final String? path;
  const ImageMessageContent({
    required this.imageUrl,
    this.width,
    this.height,
    this.path,
  }) : super(messageContentType: MessageContentType.photo);
}

class VideoMessageContent extends MessageContent {
  final String videoUrl;
  final Duration duration;
  final String? thumbnailUrl;
  final double? width;
  final double? height;
  final String? path;
  const VideoMessageContent({
    required this.videoUrl,
    required this.duration,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.path,
  }) : super(messageContentType: MessageContentType.video);
}

class FileMessageContent extends MessageContent {
  final String fileUrl;
  final String fileName;
  final int fileSize;
  final FileType? fileType;
  final String? path;
  const FileMessageContent({
    required this.fileUrl,
    required this.fileName,
    required this.fileSize,
    this.fileType,
    this.path,
  }) : super(messageContentType: MessageContentType.document);
}

class SystemMessageContent extends MessageContent {
  final SystemMessageType systemType;
  final String message;
  const SystemMessageContent({required this.systemType, required this.message})
      : super(messageContentType: MessageContentType.system);
}

class StickerMessageContent extends MessageContent {
  final String stickerUrl;
  final double? width;
  final double? height;
  final int? fileSize;
  const StickerMessageContent({
    required this.stickerUrl,
    this.width,
    this.height,
    this.fileSize,
  }) : super(messageContentType: MessageContentType.sticker);
}
