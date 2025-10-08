import 'package:json_annotation/json_annotation.dart';

import 'user_response_model.dart';

part 'message_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageResponseModel {
  const MessageResponseModel({
    required this.id,
    required this.type,
    required this.from,
    this.replyToMessage,
    this.text,
    this.entities = const [],
    this.photo = const [],
    this.video,
    this.audio,
    this.document,
    this.caption,
    this.sticker,
    required this.date,
    required this.pinned,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseModelFromJson(json);

  final String id;
  final String type;
  final UserResponseModel from;
  final ReplyMessageResponseModel? replyToMessage;
  final String? text;
  final List<EntityResponseModel> entities;
  final List<PhotoResponseModel> photo;
  final VideoResponseModel? video;
  final AudioResponseModel? audio;
  final DocumentResponseModel? document;
  final String? caption;
  final StickerResponseModel? sticker;
  final int date;
  final bool pinned;

  Map<String, dynamic> toJson() => _$MessageResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DocumentResponseModel {
  const DocumentResponseModel({
    required this.fileId,
    required this.fileUniqueId,
    required this.filePath,
    required this.fileName,
    this.mimeType,
    this.fileSize,
  });

  factory DocumentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentResponseModelFromJson(json);

  final String fileId;
  final String fileUniqueId;
  final String filePath;
  final String fileName;
  final String? mimeType;
  final int? fileSize;

  Map<String, dynamic> toJson() => _$DocumentResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VideoResponseModel {
  const VideoResponseModel({
    required this.fileId,
    required this.fileUniqueId,
    required this.filePath,
    required this.duration,
    this.thumbnail,
    this.width,
    this.height,
    this.fileName,
    this.mimeType,
    this.fileSize,
  });

  factory VideoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VideoResponseModelFromJson(json);

  final String fileId;
  final String fileUniqueId;
  final String filePath;
  final int duration;
  final int? width;
  final int? height;
  final ThumbnailResponseModel? thumbnail;
  final String? fileName;
  final String? mimeType;
  final int? fileSize;

  Map<String, dynamic> toJson() => _$VideoResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ThumbnailResponseModel {
  const ThumbnailResponseModel({
    required this.fileId,
    required this.fileUniqueId,
    required this.filePath,
    this.width,
    this.height,
    this.fileSize,
  });

  factory ThumbnailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailResponseModelFromJson(json);

  final String fileId;
  final String fileUniqueId;
  final String filePath;
  final int? width;
  final int? height;
  final int? fileSize;

  Map<String, dynamic> toJson() => _$ThumbnailResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AudioResponseModel {
  const AudioResponseModel({
    required this.fileId,
    required this.fileUniqueId,
    required this.filePath,
    required this.duration,
    required this.fileName,
    this.mimeType,
    this.fileSize,
  });

  factory AudioResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AudioResponseModelFromJson(json);

  final String fileId;
  final String fileUniqueId;
  final String filePath;
  final int duration;
  final String fileName;
  final String? mimeType;
  final int? fileSize;

  Map<String, dynamic> toJson() => _$AudioResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StickerResponseModel {
  const StickerResponseModel({
    required this.fileId,
    required this.fileUniqueId,
    required this.filePath,
    this.width,
    this.height,
    this.fileSize,
  });

  factory StickerResponseModel.fromJson(Map<String, dynamic> json) =>
      _$StickerResponseModelFromJson(json);

  final String fileId;
  final String fileUniqueId;
  final String filePath;
  final int? width;
  final int? height;
  final int? fileSize;

  Map<String, dynamic> toJson() => _$StickerResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PhotoResponseModel {
  const PhotoResponseModel({
    required this.fileId,
    required this.fileUniqueId,
    required this.filePath,
    this.width,
    this.height,
  });

  factory PhotoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoResponseModelFromJson(json);

  final String fileId;
  final String fileUniqueId;
  final String filePath;
  final int? width;
  final int? height;

  Map<String, dynamic> toJson() => _$PhotoResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EntityResponseModel {
  const EntityResponseModel({
    required this.type,
    required this.offset,
    required this.length,
  });

  factory EntityResponseModel.fromJson(Map<String, dynamic> json) =>
      _$EntityResponseModelFromJson(json);

  final String type;
  final int offset;
  final int length;

  Map<String, dynamic> toJson() => _$EntityResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ReplyMessageResponseModel {
  const ReplyMessageResponseModel({
    required this.id,
    required this.type,
    required this.from,
    this.text,
    this.entities = const [],
    this.photo = const [],
    this.video,
    this.audio,
    this.document,
    this.caption,
    this.sticker,
    required this.date,
    required this.pinned,
  });

  factory ReplyMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ReplyMessageResponseModelFromJson(json);

  final String id;
  final String type;
  final UserResponseModel from;
  final String? text;
  final List<EntityResponseModel> entities;
  final List<PhotoResponseModel> photo;
  final VideoResponseModel? video;
  final AudioResponseModel? audio;
  final DocumentResponseModel? document;
  final String? caption;
  final StickerResponseModel? sticker;
  final int date;
  final bool pinned;

  Map<String, dynamic> toJson() => _$ReplyMessageResponseModelToJson(this);
}
