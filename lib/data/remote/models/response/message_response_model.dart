import 'package:json_annotation/json_annotation.dart';

import 'user_summary_response.dart';

part 'message_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageResponseModel {
  const MessageResponseModel({
    required this.id,
    required this.type,
    required this.from,
    this.replyToMessage,
    this.text,
    this.entities,
    this.photo,
    this.video,
    this.document,
    this.caption,
    this.sticker,
    required this.date,
    required this.pinned,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseModelFromJson(json);

  final int id;
  final String type;
  final UserSummaryResponse from;
  final String? replyToMessage;
  final String? text;
  final List<String>? entities;
  final List<String?>? photo;
  final FileResponseModel? video;
  final FileResponseModel? document;
  final String? caption;
  final StickerResponseModel? sticker;
  final int date;
  final bool pinned;

  Map<String, dynamic> toJson() => _$MessageResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FileResponseModel {
  const FileResponseModel({
    required this.fileId,
    required this.fileUniqueId,
    this.thumbnail,
    required this.fileName,
    required this.mimeType,
    this.fileSize,
  });

  factory FileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FileResponseModelFromJson(json);

  final int fileId;
  final String fileUniqueId;
  final ThumbnailResponseModel? thumbnail;
  final int fileName;
  final int mimeType;
  final int? fileSize;

  Map<String, dynamic> toJson() => _$FileResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ThumbnailResponseModel {
  const ThumbnailResponseModel({
    required this.fileId,
    required this.fileUniqueId,
    this.width,
    this.height,
    this.fileSize,
  });

  factory ThumbnailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailResponseModelFromJson(json);

  final int fileId;
  final String fileUniqueId;
  final int? width;
  final int? height;
  final int? fileSize;

  Map<String, dynamic> toJson() => _$ThumbnailResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StickerResponseModel {
  const StickerResponseModel({
    required this.fileId,
    required this.fileUniqueId,
    this.width,
    this.height,
    this.fileSize,
  });

  factory StickerResponseModel.fromJson(Map<String, dynamic> json) =>
      _$StickerResponseModelFromJson(json);

  final int fileId;
  final String fileUniqueId;
  final int? width;
  final int? height;
  final int? fileSize;

  Map<String, dynamic> toJson() => _$StickerResponseModelToJson(this);
}
