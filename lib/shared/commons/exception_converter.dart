import 'package:dio/dio.dart';

import 'exceptions.dart';

class ExceptionConverter {
  static Exception convert(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ConnectionTimeoutException();
        //return ApiException(null, null, 'error.connection_timeout'.tr());
        case DioExceptionType.connectionError:
          return NoInternetException();
        default:
          // if (e.error != null && e.error is ErrorResponseModel) {
          //   final error = e.error! as ErrorResponseModel;
          //   return ApiException(error.httpCode, error.code, error.message);
          // }
          return ApiException(e.response?.statusCode, null, null);
      }
    } else if (e is ApiException) {
      return e;
    } else {
      return Exception();
    }
  }
}
