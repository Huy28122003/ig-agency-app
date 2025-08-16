class ApiException implements Exception {
  ApiException(this.httpCode, this.code, this.message);

  final int? httpCode;
  final String? code;
  final String? message;
}

class NoInternetException implements Exception {}

class ConnectionTimeoutException implements Exception {}

class UnknownException implements Exception {}
