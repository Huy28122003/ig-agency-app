class ErrorResponseModel {
  const ErrorResponseModel({this.httpCode, this.code, this.message});

  final int? httpCode;
  final String? message;
  final String? code;
}
