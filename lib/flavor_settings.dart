import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

const development = Environment('development');
const staging = Environment('staging');
const production = Environment('production');

FlavorEnvironment env = FlavorEnvironment.development;

enum FlavorEnvironment {
  development,
  staging,
  production;

  const FlavorEnvironment();

  String get baseUrl {
    return switch (this) {
      FlavorEnvironment.development => 'https://namnt.site',
      FlavorEnvironment.staging => '',
      FlavorEnvironment.production => '',
    };
  }

  FirebaseOptions get firebaseOption {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return switch (this) {
          FlavorEnvironment.development => const FirebaseOptions(
            apiKey: 'AIzaSyA_h6oPfpUY_puJ4q_a3R5tzar0ZcRV3Ec',
            appId: '1:275257763877:android:8c3d860105ef792befb7cc',
            messagingSenderId: '275257763877',
            projectId: 'ig-agency-7a016',
            storageBucket: 'ig-agency-7a016.firebasestorage.app',
          ),
          FlavorEnvironment.staging => const FirebaseOptions(
            apiKey: 'AIzaSyA_h6oPfpUY_puJ4q_a3R5tzar0ZcRV3Ec',
            appId: '1:275257763877:android:6bb2b242c9201435efb7cc',
            messagingSenderId: '275257763877',
            projectId: 'ig-agency-7a016',
            storageBucket: 'ig-agency-7a016.firebasestorage.app',
          ),
          FlavorEnvironment.production => const FirebaseOptions(
            apiKey: 'AIzaSyA_h6oPfpUY_puJ4q_a3R5tzar0ZcRV3Ec',
            appId: '1:275257763877:android:21eef02dea4dbe06efb7cc',
            messagingSenderId: '275257763877',
            projectId: 'ig-agency-7a016',
            storageBucket: 'ig-agency-7a016.firebasestorage.app',
          ),
        };
      case TargetPlatform.iOS:
        return switch (this) {
          FlavorEnvironment.development => const FirebaseOptions(
            apiKey: 'AIzaSyBwLgwV6ALGARzX8lIJTJzY4_XiTqp0l5M',
            appId: '1:275257763877:ios:b299671d56f3e0a3efb7cc',
            messagingSenderId: '275257763877',
            projectId: 'ig-agency-7a016',
            storageBucket: 'ig-agency-7a016.firebasestorage.app',
          ),
          FlavorEnvironment.staging => const FirebaseOptions(
            apiKey: 'AIzaSyBwLgwV6ALGARzX8lIJTJzY4_XiTqp0l5M',
            appId: ':275257763877:ios:309c357289d1d368efb7cc',
            messagingSenderId: '275257763877',
            projectId: 'ig-agency-7a016',
            storageBucket: 'ig-agency-7a016.firebasestorage.app',
          ),
          FlavorEnvironment.production => const FirebaseOptions(
            apiKey: 'AIzaSyBwLgwV6ALGARzX8lIJTJzY4_XiTqp0l5M',
            appId: '1:275257763877:ios:54211806c90277bfefb7cc',
            messagingSenderId: '275257763877',
            projectId: 'ig-agency-7a016',
            storageBucket: 'ig-agency-7a016.firebasestorage.app',
          ),
        };
      default:
        return switch (this) {
          FlavorEnvironment.development => const FirebaseOptions(
            apiKey: 'AIzaSyAuBpERSCO-EiTRYa741iIsNTAusYxzH-s',
            appId: '1:275257763877:web:ad7965932e989cdfefb7cc',
            messagingSenderId: '275257763877',
            projectId: 'ig-agency-7a016',
            storageBucket: 'ig-agency-7a016.firebasestorage.app',
          ),
          FlavorEnvironment.staging => const FirebaseOptions(
            apiKey: 'AIzaSyAuBpERSCO-EiTRYa741iIsNTAusYxzH-s',
            appId: '1:275257763877:web:f2aef1a198b2ccacefb7cc',
            messagingSenderId: '275257763877',
            projectId: 'ig-agency-7a016',
            storageBucket: 'ig-agency-7a016.firebasestorage.app',
          ),
          FlavorEnvironment.production => const FirebaseOptions(
            apiKey: 'AIzaSyAuBpERSCO-EiTRYa741iIsNTAusYxzH-s',
            appId: '1:275257763877:web:b5ac8f27dd497d47efb7cc',
            messagingSenderId: '275257763877',
            projectId: 'ig-agency-7a016',
            storageBucket: 'ig-agency-7a016.firebasestorage.app',
          ),
        };
    }
  }
}

class FlavorSettings {
  const FlavorSettings();

  FlavorSettings.development() {
    env = FlavorEnvironment.development;
  }

  FlavorSettings.production() {
    env = FlavorEnvironment.production;
  }

  FlavorSettings.staging() {
    env = FlavorEnvironment.staging;
  }

  String get baseUrl => env.baseUrl;

  FirebaseOptions get firebaseOption => env.firebaseOption;
}
