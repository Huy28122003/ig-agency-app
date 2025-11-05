import 'package:json_annotation/json_annotation.dart';

part 'update_group_avatar_response.g.dart';

@JsonSerializable()
class UpdateGroupAvatarResponse {
  const UpdateGroupAvatarResponse({required this.photo});

  final String photo;

  factory UpdateGroupAvatarResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateGroupAvatarResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateGroupAvatarResponseToJson(this);
}
