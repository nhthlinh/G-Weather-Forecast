// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAuLOV6OGr1-DVdVHjbpKTksXwIkthI6n4',
    appId: '1:516794526925:web:6611a419adc54f6d994d84',
    messagingSenderId: '516794526925',
    projectId: 'g-weather-forecast-43115',
    authDomain: 'g-weather-forecast-43115.firebaseapp.com',
    storageBucket: 'g-weather-forecast-43115.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_IuxtxOT42O5feQOmiyN_zShlNxWaBhg',
    appId: '1:516794526925:android:b07fd19f5437e9a0994d84',
    messagingSenderId: '516794526925',
    projectId: 'g-weather-forecast-43115',
    storageBucket: 'g-weather-forecast-43115.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAk0_lggdhoFJmmY7kJKB2KWxQKYL2CN_g',
    appId: '1:516794526925:ios:1cfdcf284329ec8d994d84',
    messagingSenderId: '516794526925',
    projectId: 'g-weather-forecast-43115',
    storageBucket: 'g-weather-forecast-43115.firebasestorage.app',
    iosBundleId: 'com.example.gFeatherForecast',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAk0_lggdhoFJmmY7kJKB2KWxQKYL2CN_g',
    appId: '1:516794526925:ios:1cfdcf284329ec8d994d84',
    messagingSenderId: '516794526925',
    projectId: 'g-weather-forecast-43115',
    storageBucket: 'g-weather-forecast-43115.firebasestorage.app',
    iosBundleId: 'com.example.gFeatherForecast',
  );
}
