import 'package:json_annotation/json_annotation.dart';

part 'base_response_model.g.dart';

@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class BaseResponseModel<T> {
  const BaseResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory BaseResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$BaseResponseModelFromJson(json, fromJsonT);

  @JsonKey(name: 'statusCode')
  final int code;
  final String? message;
  final T data;

  bool get isSuccessful => code >= 200 && code < 300;

  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$BaseResponseModelToJson(this, toJsonT);
}
