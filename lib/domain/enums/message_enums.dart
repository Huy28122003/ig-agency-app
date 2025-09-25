import 'package:easy_localization/easy_localization.dart';

enum MessageContentType {
  text,
  image,
  video,
  file,
  system;

  static MessageContentType fromString(String value) {
    switch (value) {
      case "text":
        return MessageContentType.text;
      case "photo":
        return MessageContentType.image;
      case "video":
        return MessageContentType.video;
      case "file":
        return MessageContentType.file;
      default:
        return MessageContentType.system;
    }
  }

  String get value {
    switch (this) {
      case MessageContentType.text:
        return "general.text".tr();
      case MessageContentType.image:
        return "general.photo".tr();
      case MessageContentType.video:
        return "general.video".tr();
      case MessageContentType.system:
        return "general.message".tr();
      case MessageContentType.file:
        return "general.file".tr();
    }
  }
}

enum MessageStatus { sent, delivered, read, failed, pending }

enum SystemMessageType { userJoined, userRemoved }

enum FileType { document, archive, other }

enum TextSegmentType { tag, link, search, normal }
