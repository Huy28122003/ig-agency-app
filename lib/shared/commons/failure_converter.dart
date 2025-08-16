import 'exceptions.dart';
import 'failure.dart';

class FailureConverter {
  static Failure convert(Object e) {
    if (e is ApiException) {
      return ApiFailure(message: e.message ?? 'Something went wrong');
    } else if (e is NoInternetException) {
      return NoInternetFailure();
    } else if (e is ConnectionTimeoutException) {
      return ConnectionTimeoutFailure();
    } else {
      return UnknowFailure();
    }
  }
}
