import '../../enums/message_enums.dart';
import 'text_segment.dart';

sealed class MessageContent {
  const MessageContent();

  // Text message
  factory MessageContent.text({
    required String text,
    List<TextSegment>? textSegments,
  }) = TextMessageContent;

  // Image message
  factory MessageContent.image({
    required String imageUrl,
    double? width,
    double? height,
  }) = ImageMessageContent;

  // Video message
  factory MessageContent.video({
    required String videoUrl,
    required Duration duration,
    String? thumbnailUrl,
    double? width,
    double? height,
  }) = VideoMessageContent;

  // File message
  factory MessageContent.file({
    required String fileUrl,
    required String fileName,
    required String fileExtension,
    required int fileSize,
    FileType? fileType,
  }) = FileMessageContent;

  // System message
  factory MessageContent.system({
    required SystemMessageType systemType,
    String? message,
  }) = SystemMessageContent;
}

class TextMessageContent extends MessageContent {
  final String text;
  final List<TextSegment>? textSegments;
  const TextMessageContent({required this.text, this.textSegments});
}

class ImageMessageContent extends MessageContent {
  final String imageUrl;
  final double? width;
  final double? height;
  const ImageMessageContent({required this.imageUrl, this.width, this.height});
}

class VideoMessageContent extends MessageContent {
  final String videoUrl;
  final Duration duration;
  final String? thumbnailUrl;
  final double? width;
  final double? height;
  const VideoMessageContent({
    required this.videoUrl,
    required this.duration,
    this.thumbnailUrl,
    this.width,
    this.height,
  });
}

class AudioMessageContent extends MessageContent {
  final String audioUrl;
  final Duration duration;
  final int audioSize;
  const AudioMessageContent({
    required this.audioUrl,
    required this.duration,
    required this.audioSize,
  });
}

class FileMessageContent extends MessageContent {
  final String fileUrl;
  final String fileName;
  final String fileExtension;
  final int fileSize;
  final FileType? fileType;
  const FileMessageContent({
    required this.fileUrl,
    required this.fileName,
    required this.fileExtension,
    required this.fileSize,
    this.fileType,
  });
}

class SystemMessageContent extends MessageContent {
  final SystemMessageType systemType;
  final String? message;
  const SystemMessageContent({required this.systemType, this.message});
}
