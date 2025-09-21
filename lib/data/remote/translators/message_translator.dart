import 'package:ig_agency_app/data/remote/models/response/message_response_model.dart';
import 'package:ig_agency_app/data/remote/translators/user_summary_translator.dart';
import 'package:ig_agency_app/domain/entities/message/message_entity.dart';
import 'package:ig_agency_app/domain/entities/message/message_content.dart';
import 'package:ig_agency_app/domain/entities/message/text_segment.dart';
import 'package:ig_agency_app/domain/enums/message_enums.dart';

extension MessageTranslatorExtension on MessageResponseModel {
  MessageEntity toEntity() {
    return MessageEntity(
      id: id.toString(),
      user: from.toEntity(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(date),
      content: _mapContent(),
      status: MessageStatus.sent,
      repliedMessage: null,
      isPinned: pinned,
      pinnedAt: pinned ? DateTime.fromMillisecondsSinceEpoch(date) : null,
    );
  }

  MessageContent _mapContent() {
    switch (type.toLowerCase()) {
      case 'text':
        return TextMessageContent(
          text: text ?? '',
          textSegments: _mapTextSegments(),
        );

      case 'photo':
      case 'image':
        final photos = photo;
        return ImageMessageContent(
          imageUrl: photos != null && photos.isNotEmpty
              ? (photos.first ?? '')
              : '',
          width: null,
          height: null,
        );

      case 'video':
        final thumbnail = video?.thumbnail;
        return VideoMessageContent(
          videoUrl: '',
          duration: const Duration(seconds: 0),
          thumbnailUrl: '',
          width: thumbnail?.width?.toDouble(),
          height: thumbnail?.height?.toDouble(),
        );

      case 'document':
      case 'audio':
      case 'voice':
        return FileMessageContent(
          fileUrl: '',
          fileName: document?.fileName.toString() ?? '',
          fileExtension: _getFileExtension(document?.fileName.toString() ?? ''),
          fileSize: document?.fileSize ?? 0,
          fileType: FileType.document,
        );

      case 'sticker':
        return StickerMessageContent(
          stickerUrl: '',
          width: sticker?.width,
          height: sticker?.height,
          fileSize: sticker?.fileSize,
        );

      default:
        return TextMessageContent(text: text ?? '');
    }
  }

  List<TextSegment>? _mapTextSegments() {
    if (entities == null || entities!.isEmpty) return null;

    return entities!
        .asMap()
        .entries
        .map(
          (entry) => TextSegment(
            type: TextSegmentType.normal,
            start: entry.key,
            end: entry.key + entry.value.length,
            extra: entry.value,
          ),
        )
        .toList();
  }

  String _getFileExtension(String fileName) {
    final lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1) return '';
    return fileName.substring(lastDotIndex + 1);
  }
}
