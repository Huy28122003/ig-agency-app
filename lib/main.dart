import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/shared/utils/bloc_observer.dart';

import 'app/app.dart';
import 'di/di.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      EasyLocalization.ensureInitialized();
      Bloc.observer = AppBlocObserver();
      await configureDependencies();
      getIt.registerSingleton(AppRouter());
      _startApp();
    },
    (error, stackTrace) {
      print("${error.toString()} $stackTrace");
    },
  );
}

void _startApp() async {
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('vn')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: const MyApp(),
    ),
  );
}
