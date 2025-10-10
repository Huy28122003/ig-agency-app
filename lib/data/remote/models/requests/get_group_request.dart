import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_group_request.g.dart';

@JsonSerializable()
class GetGroupRequest {
  final int limit;
  final int offset;
  final String? search;

  GetGroupRequest({
    required this.limit,
    required this.offset,
    this.search,
  });

  Map<String, dynamic> toJson() => _$GetGroupRequestToJson(this);
}
