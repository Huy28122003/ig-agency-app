import 'package:easy_localization/easy_localization.dart';

enum MessageContentType {
  text("text"),
  photo("photo"),
  video("video"),
  audio("audio"),
  voice("voice"),
  document("document"),
  sticker("sticker"),
  unknown("unknown"),
  system("system");

  final String code;

  const MessageContentType(this.code);

  static MessageContentType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return MessageContentType.text;
      case 'photo':
        return MessageContentType.photo;
      case 'video':
        return MessageContentType.video;
      case 'document':
        return MessageContentType.document;
      case 'audio':
        return MessageContentType.audio;
      case 'voice':
        return MessageContentType.voice;
      case 'sticker':
        return MessageContentType.sticker;
      case 'system':
        return MessageContentType.system;
      case 'unknown':
        return MessageContentType.unknown;
      default:
        return MessageContentType.text;
    }
  }

  String get value {
    switch (this) {
      case MessageContentType.text:
        return "general.text".tr();
      case MessageContentType.photo:
        return "general.photo".tr();
      case MessageContentType.video:
        return "general.video".tr();
      default:
        return "general.message".tr();
    }
  }
}

enum MessageStatus { sent, delivered, read, failed, pending }

enum SystemMessageType { userJoined, userRemoved }

enum FileType {
  document("document"),
  audio("audio"),
  voice("voice");

  final String code;

  const FileType(this.code);

  static FileType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'document':
        return FileType.document;
      case 'audio':
        return FileType.audio;
      case 'voice':
        return FileType.voice;
      default:
        return FileType.document;
    }
  }
}

enum TextSegmentType {
  tag("mention"),
  link("link"),
  search("search"),
  normal("normal");

  final String code;

  const TextSegmentType(this.code);

  static TextSegmentType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'text-mention':
      case 'mention':
        return TextSegmentType.tag;
      case 'url':
        return TextSegmentType.link;
      case 'search':
        return TextSegmentType.search;
      default:
        return TextSegmentType.normal;
    }
  }
}
