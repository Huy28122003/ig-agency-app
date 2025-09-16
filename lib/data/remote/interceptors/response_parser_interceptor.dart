import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/response/error_response_mode.dart';

class ResponseParserInterceptor extends Interceptor {
  @factoryMethod
  ResponseParserInterceptor();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      final Map<String, dynamic> valueMap;
      if (response.data is String) {
        valueMap = jsonDecode(response.data as String) as Map<String, dynamic>;
      } else {
        valueMap = response.data as Map<String, dynamic>;
      }
      final int statusCode =
          valueMap['statusCode'] as int? ?? response.statusCode ?? 0;
      final success = statusCode >= 200 && statusCode < 300;
      if (success) {
        final data = valueMap['data'];
        response.data = data;
        return handler.next(response);
      } else {
        final code = valueMap['statusCode'] as int?;
        final message = valueMap['message'] as String?;
        return handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            error: ErrorResponseModel(
              httpCode: response.statusCode,
              code: "$code",
              message: message,
            ),
          ),
        );
      }
    } catch (e) {
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          error: ErrorResponseModel(httpCode: response.statusCode),
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    if (response != null) {
      try {
        final valueMap = response.data as Map<String, dynamic>;
        final code = valueMap['statusCode'] as int;
        final message = valueMap['message'] as String;
        return handler.next(
          err.copyWith(
            error: ErrorResponseModel(
              httpCode: response.statusCode,
              code: '$code',
              message: message,
            ),
          ),
        );
      } catch (error) {
        return handler.next(err);
      }
    } else {
      return handler.next(err);
    }
  }
}
