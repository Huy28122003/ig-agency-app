import 'package:json_annotation/json_annotation.dart';
import 'package:ig_agency_app/domain/enums/role.dart';

part 'user_response_model.g.dart';

@JsonSerializable()
class UserResponseModel {
  const UserResponseModel({
    required this.id,
    required this.name,
    required this.role,
    required this.status,
    this.avatar,
    this.bio,
  });

  final String id;
  final String name;
  final String? avatar;
  final String? bio;
  @JsonKey(fromJson: _roleFromJson, toJson: _roleToJson)
  final RoleSystem role;
  final String status;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);

  static RoleSystem _roleFromJson(String role) => RoleSystem.fromString(role);
  static String _roleToJson(RoleSystem role) => role.code;
}
