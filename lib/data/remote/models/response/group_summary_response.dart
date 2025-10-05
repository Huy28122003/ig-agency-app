import 'package:json_annotation/json_annotation.dart';

part 'group_summary_response.g.dart';

@JsonSerializable()
class GroupSummaryResponse {
  const GroupSummaryResponse({
    required this.id,
    required this.name,
    required this.avatar,
  });

  final String id;
  final String name;
  @JsonKey(defaultValue: '')
  final String avatar;

  factory GroupSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupSummaryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GroupSummaryResponseToJson(this);
}
