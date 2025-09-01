import 'package:json_annotation/json_annotation.dart';

part 'user_summary_response.g.dart';

@JsonSerializable()
class UserSummaryResponse {
  const UserSummaryResponse({
    required this.id,
    required this.name,
    required this.avatar,
  });

  final int id;
  final String name;
  final String avatar;

  factory UserSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$UserSummaryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserSummaryResponseToJson(this);
}
