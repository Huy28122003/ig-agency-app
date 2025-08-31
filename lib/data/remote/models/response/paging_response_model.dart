import 'package:json_annotation/json_annotation.dart';

part 'paging_response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PagingResponseModel<T> {
  const PagingResponseModel({required this.total, required this.records});

  factory PagingResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PagingResponseModelFromJson(json, fromJsonT);

  @JsonKey(name: 'total_records')
  final int total;
  @JsonKey(name: 'result')
  final List<T> records;
}
