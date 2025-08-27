import 'dart:async';

import 'package:injectable/injectable.dart';

@lazySingleton
class RamCache {
  RamCache();

  bool? _latestProfileValue;
  StreamController<bool> _profileInfoController =
      StreamController<bool>.broadcast();

  void saveProfileInfo(bool data) {
    if (_profileInfoController.isClosed) {
      _profileInfoController = StreamController<bool>.broadcast();
    }
    _profileInfoController.sink.add(data);
    _latestProfileValue = data;
  }

  Stream<bool> getProfileInfoStream() {
    if (_profileInfoController.isClosed) {
      _profileInfoController = StreamController<bool>.broadcast();
    }
    if (_latestProfileValue != null) {
      Future.microtask(
        () => {_profileInfoController.sink.add(_latestProfileValue!)},
      );
    }

    return _profileInfoController.stream;
  }

  void clearUserData() {
    _latestProfileValue = null;
    _profileInfoController.close();
  }
}
