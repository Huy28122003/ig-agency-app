import 'dart:async';

import 'package:flutter/foundation.dart';

class Debounce {
  Debounce({required this.milliseconds});

  final int milliseconds;
  Timer? _timer;

  // ignore: always_declare_return_types
  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(
      Duration(milliseconds: milliseconds),
      action,
    );
  }

  void dispose() {
    _timer?.cancel();
  }
}
