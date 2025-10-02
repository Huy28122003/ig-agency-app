import 'failure.dart';

class ValidationFailure extends Failure {
  ValidationFailure({String message = 'An unknown error occurred'})
    : super(message: message);
}

class OtpExpiredFailure extends ValidationFailure {
  OtpExpiredFailure() : super(message: 'An unknown error occurred');
}
