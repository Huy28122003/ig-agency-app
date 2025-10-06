import 'package:json_annotation/json_annotation.dart';
import 'package:ig_agency_app/data/remote/models/response/user_response_model.dart';

part 'member_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MemberResponseModel {
  const MemberResponseModel({required this.user, required this.status});

  factory MemberResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MemberResponseModelFromJson(json);

  final UserResponseModel user;
  final String status;

  Map<String, dynamic> toJson() => _$MemberResponseModelToJson(this);
}
