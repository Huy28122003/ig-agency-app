import 'package:json_annotation/json_annotation.dart';

part 'profile_info_response.g.dart';

@JsonSerializable()
class ProfileInfoResponse {
  const ProfileInfoResponse(
    this.id,
    this.name,
    this.avatar,
    this.role,
    this.bio,
    this.status,
  );

  final String? id;
  final String? name;
  final String? avatar;
  final String? role;
  final String? bio;
  final String? status;

  factory ProfileInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileInfoResponseToJson(this);
}
