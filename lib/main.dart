import 'dart:async';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig_agency_app/app/app_bloc.dart';
import 'package:ig_agency_app/presentation/routers/app_router.dart';
import 'package:ig_agency_app/shared/utils/bloc_observer.dart';
import 'package:ig_agency_app/shared/utils/logger.dart';

import 'app/app.dart';
import 'dependencies/notification/notification_service.dart';
import 'di/di.dart';
import 'flavor_settings.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      await configureDependencies();
      await _setupFirebase();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      EasyLocalization.ensureInitialized();
      Bloc.observer = AppBlocObserver();
      getIt.registerSingleton(AppRouter());
      await getIt<NotificationService>().init();
      _startApp();
    },
    (error, stackTrace) {
      logger.e(error.toString(), stackTrace: stackTrace);
    },
  );
}

Future _setupFirebase() async {
  try {
    await Firebase.initializeApp(
      options: const FlavorSettings().firebaseOption,
    ).then((_) async {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      if (!kIsWeb &&
          (Platform.isAndroid || Platform.isIOS || Platform.isMacOS)) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          true,
        );
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
      }
    });
  } catch (e) {
    logger.e('Firebase initialization error: $e');
  }
}

void _startApp() async {
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('vn')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: BlocProvider<AppBloc>(
        create: (context) => context.read<AppBloc>(),
        child: const MyApp(),
      ),
    ),
  );
}
