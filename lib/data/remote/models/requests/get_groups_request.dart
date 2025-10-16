import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_groups_request.g.dart';

@JsonSerializable()
class GetGroupsRequest {
  final int limit;
  final int offset;
  final String? search;

  GetGroupsRequest({
    required this.limit,
    required this.offset,
    this.search,
  });

  Map<String, dynamic> toJson() => _$GetGroupsRequestToJson(this);
}
