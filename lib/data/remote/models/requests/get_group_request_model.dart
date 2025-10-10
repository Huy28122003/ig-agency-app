import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_workspaces_request_model.g.dart';

@JsonSerializable()
class GetWorkspacesRequestModel {
  final int limit;
  final int offset;
  final String? search;

  GetWorkspacesRequestModel({
    required this.limit,
    required this.offset,
    this.search,
  });

  Map<String, dynamic> toJson() => _$GetWorkspacesRequestModelToJson(this);
}
