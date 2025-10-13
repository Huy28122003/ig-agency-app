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

  static MessageContentType fromCode(String code) {
    return MessageContentType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => MessageContentType.unknown,
    );
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

  static FileType fromCode(String code) {
    return FileType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => FileType.document,
    );
  }
}

enum TextSegmentType {
  tag("mention"),
  link("link"),
  search("search"),
  normal("normal");

  final String code;

  const TextSegmentType(this.code);

  static TextSegmentType fromCode(String code) {
    return TextSegmentType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => TextSegmentType.normal,
    );
  }
}
