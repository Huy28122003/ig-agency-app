import 'package:json_annotation/json_annotation.dart';

part 'user_response_model.g.dart';

@JsonSerializable()
class UserResponseModel {
  const UserResponseModel({
    required this.id,
    required this.name,
    required this.role,
    required this.status,
    this.avatar,
  });

  final String id;
  final String name;
  final String? avatar;
  final String role;
  final String status;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);
}
