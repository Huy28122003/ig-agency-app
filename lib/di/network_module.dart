import 'package:flutter/foundation.dart';
import 'package:ig_agency_app/data/local/app/auth_local_data_source.dart';
import 'package:ig_agency_app/data/remote/interceptors/connectivity_interceptor.dart';
import 'package:ig_agency_app/dependencies/connectivity/connectivity_manager.dart';
import 'package:ig_agency_app/di/di.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../data/remote/interceptors/response_parser_interceptor.dart';
import '../data/remote/interceptors/token_interceptor.dart';
import '../data/remote/services/api_services.dart';

@module
abstract class NetworkModule {
  @Named('logging_interceptor')
  @singleton
  Interceptor get loggingInterceptor => PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    error: true,
    compact: false,
    responseBody: true,
    maxWidth: 150,
    logPrint: (o) => debugPrint('API ${o.toString()}'),
  );

  @Named('response_parser_interceptor')
  @singleton
  Interceptor responseParserInterceptor() {
    return ResponseParserInterceptor();
  }

  @Named('token_interceptor')
  @singleton
  Interceptor tokenInterceptor() {
    return TokenInterceptor(getIt<AuthLocalDataSource>());
  }

  @Named('connectivity_interceptor')
  @singleton
  Interceptor connectivityInterceptor() {
    return ConnectivityInterceptor(getIt<ConnectivityManager>());
  }

  @lazySingleton
  Dio getDio(
    @Named('response_parser_interceptor') Interceptor responseParserInterceptor,
    @Named('token_interceptor') Interceptor tokenInterceptor,
    @Named('connectivity_interceptor') Interceptor connectivityInterceptor,
  ) {
    final dio = Dio();
    dio.options = BaseOptions(
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    );
    dio.interceptors.addAll([
      connectivityInterceptor,
      tokenInterceptor,
      responseParserInterceptor,
    ]);
    if (kDebugMode) {
      dio.interceptors.add(loggingInterceptor);
    }
    return dio;
  }

  @singleton
  ApiService getApiService(Dio dio) {
    return ApiService(dio, baseUrl: 'https://namnt.site');
  }
}
