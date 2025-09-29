enum MessageContentType {
  text,
  photo,
  video,
  audio,
  voice,
  document,
  sticker,
  unknown,
  system,
}

enum MessageStatus { sent, delivered, read, failed, pending }

enum SystemMessageType { userJoined, userRemoved }

enum FileType { document, archive, other }

enum TextSegmentType { tag, link, search, normal }
