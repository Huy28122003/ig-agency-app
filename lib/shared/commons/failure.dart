class Failure {
  final String? message;
  final String? title;

  Failure({this.title, this.message});

  @override
  String toString() => 'Failure: $message';
}

class ConnectionTimeoutFailure extends Failure {
  ConnectionTimeoutFailure() : super(message: 'Connection timed out');
}

class NoInternetFailure extends Failure {
  NoInternetFailure() : super(message: 'No internet connection');
}

class ApiFailure extends Failure {
  final int? httpCode;
  final String? code;

  ApiFailure({this.httpCode, this.code, required super.message});

  @override
  String toString() =>
      'ApiFailure: $message (HTTP Code: $httpCode, Code: $code)';
}

class UnknowFailure extends Failure {
  UnknowFailure() : super(message: 'An unknown error occurred');
}

extension FailureExtension on Failure? {
  Failure? operator &(bool other) {
    return other ? this : null;
  }
}
