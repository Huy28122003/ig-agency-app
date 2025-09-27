import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_data_in_group_request.g.dart';

@JsonSerializable()
class GetDataInGroupRequest {
  final int limit;
  final int offset;
  final String groupId;

  GetDataInGroupRequest({
    required this.limit,
    required this.offset,
    required this.groupId,
  });

  Map<String, dynamic> toJson() => _$GetDataInGroupRequestToJson(this);
}
