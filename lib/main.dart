import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.ensureInitialized();
  _startApp;
}

void _startApp() {
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('vn', 'VN')],
      path: 'assets/translations',
      child: const MyApp(),
    ),
  );
}
