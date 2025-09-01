import 'package:json_annotation/json_annotation.dart';

part 'paged_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PagedResponse<T> {
  const PagedResponse({required this.total, required this.records});

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PagedResponseFromJson(json, fromJsonT);

  @JsonKey(name: 'total_records')
  final int total;
  @JsonKey(name: 'result')
  final List<T> records;
}
