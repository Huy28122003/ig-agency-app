import 'package:dio/dio.dart';
import 'package:ig_agency_app/dependencies/connectivity/connectivity_manager.dart';

class ConnectivityInterceptor extends Interceptor {
  final ConnectivityManager _connectivityManager;

  ConnectivityInterceptor(this._connectivityManager);

  @override
  void onRequest(RequestOptions options, handler) async {
    final isConnected = await _connectivityManager.isNetworkAvailable();
    if (isConnected) {
      handler.next(options);
    } else {
      handler.reject(
        DioException(
          message: 'No Internet Connection',
          type: DioExceptionType.connectionError,
          requestOptions: options,
        ),
      );
    }
  }
}
