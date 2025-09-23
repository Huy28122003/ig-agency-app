import 'package:ig_agency_app/data/remote/models/response/message_response_model.dart';
import 'package:ig_agency_app/data/remote/translators/user_summary_translator.dart';
import 'package:ig_agency_app/data/remote/translators/entity_translator.dart';
import 'package:ig_agency_app/domain/entities/message/message_entity.dart';
import 'package:ig_agency_app/domain/entities/message/message_content.dart';
import 'package:ig_agency_app/domain/entities/message/text_segment.dart';
import 'package:ig_agency_app/domain/enums/message_enums.dart';

extension MessageTranslatorExtension on MessageResponseModel {
  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      user: from.toEntity(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(date * 1000),
      content: _mapContent(),
      status: MessageStatus.sent,
      repliedMessage: replyToMessage != null
          ? _mapReplyMessage(replyToMessage!)
          : null,
      isPinned: pinned,
      pinnedAt: null,
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
        final photos = photo;
        if (photos != null && photos.isNotEmpty) {
          final firstPhoto = photos.first;
          return ImageMessageContent(
            imageUrl: '',
            width: firstPhoto.width?.toDouble(),
            height: firstPhoto.height?.toDouble(),
          );
        }
        return ImageMessageContent(imageUrl: '', width: null, height: null);

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
          fileName: document?.fileName ?? '',
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

    return entities!.map((entity) => entity.toTextSegment()).toList();
  }

  MessageEntity _mapReplyMessage(ReplyMessageResponseModel replyMessage) {
    return MessageEntity(
      id: replyMessage.id,
      user: replyMessage.from.toEntity(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(replyMessage.date * 1000),
      content: _mapReplyContent(replyMessage),
      status: MessageStatus.sent,
      repliedMessage: null, // Reply message không có nested reply
      isPinned: replyMessage.pinned,
      pinnedAt: null,
    );
  }

  MessageContent _mapReplyContent(ReplyMessageResponseModel replyMessage) {
    switch (replyMessage.type.toLowerCase()) {
      case 'text':
        return TextMessageContent(text: replyMessage.text ?? '');

      case 'photo':
        final photos = replyMessage.photo;
        if (photos != null && photos.isNotEmpty) {
          final firstPhoto = photos.first;
          return ImageMessageContent(
            imageUrl: '',
            width: firstPhoto.width?.toDouble(),
            height: firstPhoto.height?.toDouble(),
          );
        }
        return ImageMessageContent(imageUrl: '', width: null, height: null);

      case 'video':
        final thumbnail = replyMessage.video?.thumbnail;
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
          fileName: replyMessage.document?.fileName ?? '',
          fileSize: replyMessage.document?.fileSize ?? 0,
          fileType: FileType.document,
        );

      case 'sticker':
        return StickerMessageContent(
          stickerUrl: replyMessage.sticker?.fileId ?? '',
          width: replyMessage.sticker?.width,
          height: replyMessage.sticker?.height,
          fileSize: replyMessage.sticker?.fileSize,
        );

      default:
        return TextMessageContent(text: replyMessage.text ?? '');
    }
  }
}
