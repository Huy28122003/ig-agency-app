import 'package:ig_agency_app/data/remote/models/response/message_response_model.dart';
import 'package:ig_agency_app/data/remote/translators/entity_translator.dart';
import 'package:ig_agency_app/data/remote/translators/user_translator.dart';
import 'package:ig_agency_app/domain/entities/message/message_entity.dart';
import 'package:ig_agency_app/domain/entities/message/message_content.dart';
import 'package:ig_agency_app/domain/entities/message/text_segment.dart';
import 'package:ig_agency_app/domain/enums/message_enums.dart';
import 'package:ig_agency_app/shared/extensions/date_time_extension.dart';
import 'package:ig_agency_app/shared/extensions/string.dart';

extension MessageTranslatorExtension on MessageResponseModel {
  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      user: from.toEntity(),
      createdAt: date.toLocalTime(isSecond: true),
      content: _mapContent(),
      status: MessageStatus.sent,
      repliedMessage: replyToMessage != null
          ? _mapReplyMessage(replyToMessage!)
          : null,
      isPinned: pinned,
      // pinnedAt: null,
    );
  }

  MessageContent _mapContent() {
    final messageContentType = MessageContentType.fromCode(type);
    switch (messageContentType) {
      case MessageContentType.text:
        return TextMessageContent(
          text: text ?? '',
          textSegments: _mapTextSegments(),
        );
      case MessageContentType.photo:
        final photos = photo;
        if (photos.isNotEmpty) {
          final firstPhoto = photos.first;
          return ImageMessageContent(
            imageUrl: firstPhoto.filePath.withBaseUrl(),
            width: firstPhoto.width?.toDouble(),
            height: firstPhoto.height?.toDouble(),
            path: firstPhoto.filePath,
          );
        }
        return ImageMessageContent(imageUrl: '', width: null, height: null);
      case MessageContentType.video:
        final videoData = video;
        final thumbnail = videoData?.thumbnail;
        return VideoMessageContent(
          videoUrl: videoData?.filePath.withBaseUrl() ?? '',
          duration: Duration(seconds: videoData?.duration ?? 0),
          thumbnailUrl: thumbnail?.filePath.withBaseUrl(),
          width: videoData?.width?.toDouble(),
          height: videoData?.height?.toDouble(),
          path: videoData?.filePath,
        );
      case MessageContentType.document:
        return FileMessageContent(
          fileUrl: document?.filePath.withBaseUrl() ?? '',
          fileName: document?.fileName ?? '',
          fileSize: document?.fileSize ?? 0,
          fileType: FileType.document,
          path: document?.filePath,
        );
      case MessageContentType.audio:
        return FileMessageContent(
          fileUrl: audio?.filePath.withBaseUrl() ?? '',
          fileName: audio?.fileName ?? '',
          fileSize: audio?.fileSize ?? 0,
          fileType: FileType.audio,
          path: audio?.filePath,
        );
      case MessageContentType.sticker:
        return StickerMessageContent(
          stickerUrl: sticker?.filePath.withBaseUrl() ?? '',
          width: sticker?.width?.toDouble(),
          height: sticker?.height?.toDouble(),
          fileSize: sticker?.fileSize,
        );
      default:
        return TextMessageContent(text: text ?? '');
    }
  }

  List<TextSegment>? _mapTextSegments() {
    if (entities.isEmpty) return null;

    return entities.map((entity) => entity.toTextSegment()).toList();
  }

  MessageEntity _mapReplyMessage(ReplyMessageResponseModel replyMessage) {
    return MessageEntity(
      id: replyMessage.id,
      user: replyMessage.from.toEntity(),
      createdAt: replyMessage.date.toLocalTime(isSecond: true),
      content: _mapReplyContent(replyMessage),
      status: MessageStatus.sent,
      repliedMessage: null,
      // Reply message không có nested reply
      isPinned: replyMessage.pinned,
      // pinnedAt: null,
    );
  }

  MessageContent _mapReplyContent(ReplyMessageResponseModel replyMessage) {
    final messageContentType = MessageContentType.fromCode(replyMessage.type);
    switch (messageContentType) {
      case MessageContentType.text:
        return TextMessageContent(text: replyMessage.text ?? '');
      case MessageContentType.photo:
        final photos = replyMessage.photo;
        if (photos.isNotEmpty) {
          final firstPhoto = photos.first;
          return ImageMessageContent(
            imageUrl: firstPhoto.filePath.withBaseUrl(),
            width: firstPhoto.width?.toDouble(),
            height: firstPhoto.height?.toDouble(),
            path: firstPhoto.filePath,
          );
        }
        return ImageMessageContent(imageUrl: '', width: null, height: null);
      case MessageContentType.video:
        final videoData = replyMessage.video;
        final thumbnail = videoData?.thumbnail;
        return VideoMessageContent(
          videoUrl: videoData?.filePath.withBaseUrl() ?? '',
          duration: Duration(seconds: videoData?.duration ?? 0),
          thumbnailUrl: thumbnail?.filePath.withBaseUrl(),
          width: thumbnail?.width?.toDouble(),
          height: thumbnail?.height?.toDouble(),
          path: videoData?.filePath,
        );
      case MessageContentType.document:
        return FileMessageContent(
          fileUrl: replyMessage.document?.filePath.withBaseUrl() ?? '',
          fileName: replyMessage.document?.fileName ?? '',
          fileSize: replyMessage.document?.fileSize ?? 0,
          fileType: FileType.document,
          path: replyMessage.document?.filePath,
        );
      case MessageContentType.audio:
        return FileMessageContent(
          fileUrl: replyMessage.audio?.filePath.withBaseUrl() ?? '',
          fileName: replyMessage.audio?.fileName ?? '',
          fileSize: replyMessage.audio?.fileSize ?? 0,
          fileType: FileType.audio,
          path: replyMessage.audio?.filePath,
        );
      case MessageContentType.sticker:
        return StickerMessageContent(
          stickerUrl: replyMessage.sticker?.filePath.withBaseUrl() ?? '',
          width: replyMessage.sticker?.width?.toDouble(),
          height: replyMessage.sticker?.height?.toDouble(),
          fileSize: replyMessage.sticker?.fileSize,
        );

      default:
        return TextMessageContent(text: replyMessage.text ?? '');
    }
  }
}
