import 'dart:async';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/shared/utils/bloc_observer.dart';

import 'app/app.dart';
import 'di/di.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      Bloc.observer = AppBlocObserver();
      await configureDependencies();
      getIt.registerSingleton(AppRouter());
      FlutterNativeSplash.remove();
      _startApp();
    },
    (error, stackTrace) {
      print("${error.toString()} $stackTrace");
    },
  );
}

void _startApp() async {
  runApp(MyApp());
}
