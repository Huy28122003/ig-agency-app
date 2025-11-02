class AppException implements Exception {
  AppException();
}

class ApiException implements AppException {
  ApiException(this.httpCode, this.code, this.message);

  final int? httpCode;
  final String? code;
  final String? message;
}

class NoInternetException extends AppException {}

class ConnectionTimeoutException extends AppException {}

class UnknownException implements Exception {}

class NoFileFoundException extends AppException {}
