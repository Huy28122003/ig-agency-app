import 'package:json_annotation/json_annotation.dart';

part 'user_profile_response_model.g.dart';

@JsonSerializable()
class UserProfileResponseModel {
  const UserProfileResponseModel(
    this.id,
    this.name,
    this.avatar,
    this.bio,
    this.role,
    this.status,
  );

  final String? id;
  final String? name;
  final String? avatar;
  final String? bio;
  final String? role;
  final String? status;

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileResponseModelToJson(this);
}
