import 'package:equatable/equatable.dart';
import '../../enums/message_enums.dart';
import 'text_segment.dart';

sealed class MessageContent extends Equatable {
  const MessageContent();

  // Text message
  const factory MessageContent.text({
    required String text,
    List<TextSegment>? textSegments,
  }) = TextMessageContent;

  // Image message
  const factory MessageContent.image({
    required String imageUrl,
    double? width,
    double? height,
    String? path,
  }) = ImageMessageContent;

  // Video message
  const factory MessageContent.video({
    required String videoUrl,
    required Duration duration,
    String? thumbnailUrl,
    double? width,
    double? height,
    String? path,
  }) = VideoMessageContent;

  // File message
  const factory MessageContent.file({
    required String fileUrl,
    required String fileName,
    required String fileExtension,
    required int fileSize,
    FileType? fileType,
    String? path,
  }) = FileMessageContent;

  // System message
  const factory MessageContent.system({
    required SystemMessageType systemType,
    required String message,
  }) = SystemMessageContent;
}

class TextMessageContent extends MessageContent {
  final String text;
  final List<TextSegment>? textSegments;
  const TextMessageContent({required this.text, this.textSegments});

  @override
  List<Object?> get props => [text, textSegments];
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
  });

  @override
  List<Object?> get props => [imageUrl, width, height, path];
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
  });

  @override
  List<Object?> get props => [
    videoUrl,
    duration,
    thumbnailUrl,
    width,
    height,
    path,
  ];
}

class FileMessageContent extends MessageContent {
  final String fileUrl;
  final String fileName;
  final String fileExtension;
  final int fileSize;
  final FileType? fileType;
  final String? path;
  const FileMessageContent({
    required this.fileUrl,
    required this.fileName,
    required this.fileExtension,
    required this.fileSize,
    this.fileType,
    this.path,
  });

  @override
  List<Object?> get props => [
    fileUrl,
    fileName,
    fileExtension,
    fileSize,
    fileType,
    path,
  ];
}

class SystemMessageContent extends MessageContent {
  final SystemMessageType systemType;
  final String message;
  const SystemMessageContent({required this.systemType, required this.message});

  @override
  List<Object?> get props => [systemType, message];
}
