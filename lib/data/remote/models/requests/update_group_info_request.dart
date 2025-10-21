import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_group_info_request.g.dart';

@JsonSerializable()
class UpdateGroupInfoRequest {
  final String? title;
  final GroupAvatarRequest? photo;
  final String? bio;

  UpdateGroupInfoRequest({this.photo, this.title, this.bio});

  factory UpdateGroupInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateGroupInfoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateGroupInfoRequestToJson(this);
}

@JsonSerializable()
class GroupAvatarRequest {
  final String smallFileId;
  final String smallFileUniqueId;
  final String smallFilePath;
  final String bigFileId;
  final String bigFileUniqueId;
  final String bigFilePath;

  GroupAvatarRequest({
    required this.smallFileId,
    required this.smallFileUniqueId,
    required this.smallFilePath,
    required this.bigFileId,
    required this.bigFileUniqueId,
    required this.bigFilePath,
  });

  factory GroupAvatarRequest.fromJson(Map<String, dynamic> json) =>
      _$GroupAvatarRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GroupAvatarRequestToJson(this);
}
