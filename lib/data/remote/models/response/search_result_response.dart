import 'package:ig_agency_app/data/remote/models/response/message_summary_response.dart';
import 'package:ig_agency_app/data/remote/models/response/user_summary_response.dart';
import 'package:json_annotation/json_annotation.dart';

import 'group_summary_response.dart';

part 'search_result_response.g.dart';

@JsonSerializable()
class SearchResultResponse {
  const SearchResultResponse({
    required this.id,
    required this.groupInfo,
    this.userInfo,
    this.messageInfo,
  });

  final String id;
  final GroupSummaryResponse groupInfo;
  final UserSummaryResponse? userInfo;
  final MessageSummaryResponse? messageInfo;

  factory SearchResultResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResultResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultResponseToJson(this);
}
