import 'package:ig_agency_app/dependencies/connectivity/connectivity_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ConnectivityManager)
class ConnectivityPlusImpl extends ConnectivityManager {
  final _connectivity = Connectivity();

  @override
  Future<bool> isNetworkAvailable() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
