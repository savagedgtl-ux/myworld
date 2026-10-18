import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../core/config/app_config.dart';

/// Initializes Firebase from the native config files
/// (android/app/google-services.json, ios/Runner/GoogleService-Info.plist).
Future<void> bootstrapFirebase() async {
  await Firebase.initializeApp();

  if (AppConfig.useEmulators) {
    final host = AppConfig.emulatorHost;
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    await FirebaseStorage.instance.useStorageEmulator(host, 9199);
    FirebaseFunctions.instanceFor(region: AppConfig.functionsRegion).useFunctionsEmulator(host, 5001);
  } else if (AppConfig.isProd) {
    // App Check only in production builds distributed via the stores; test
    // APKs installed manually can't pass Play Integrity / App Attest.
    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode ? const AndroidDebugProvider() : const AndroidPlayIntegrityProvider(),
      providerApple: kDebugMode ? const AppleDebugProvider() : const AppleAppAttestWithDeviceCheckFallbackProvider(),
    );
  }

  // Crash reporting without personal data: we never attach document content,
  // titles or user-entered text as custom keys.
  final crash = FirebaseCrashlytics.instance;
  await crash.setCrashlyticsCollectionEnabled(!kDebugMode && !AppConfig.useEmulators);
  FlutterError.onError = crash.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    crash.recordError(error, stack, fatal: true);
    return true;
  };
}
