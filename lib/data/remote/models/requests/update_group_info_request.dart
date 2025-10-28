import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_group_info_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateGroupInfoRequest {
  final String? title;
  final String? photo;
  final String? bio;

  UpdateGroupInfoRequest({this.photo, this.title, this.bio});

  factory UpdateGroupInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateGroupInfoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateGroupInfoRequestToJson(this);
}

