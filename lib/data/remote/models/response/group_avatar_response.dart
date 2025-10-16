import 'package:json_annotation/json_annotation.dart';
part 'group_avatar_response.g.dart';

@JsonSerializable()
class GroupAvatarResponse {
  final String smallFileId;
  final String smallFileUniqueId;
  final String smallFilePath;
  final String bigFileId;
  final String bigFileUniqueId;
  final String bigFilePath;

  GroupAvatarResponse({
    required this.smallFileId,
    required this.smallFileUniqueId,
    required this.smallFilePath,
    required this.bigFileId,
    required this.bigFileUniqueId,
    required this.bigFilePath,
  });

  factory GroupAvatarResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupAvatarResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GroupAvatarResponseToJson(this);
}
