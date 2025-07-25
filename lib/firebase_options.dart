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
        return windows;
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
    apiKey: 'AIzaSyDshBys5XRmClOTIvSDXKOZl5864pQ64sg',
    appId: '1:328568344086:web:ece9b85c6d80b68a1e2f37',
    messagingSenderId: '328568344086',
    projectId: 'spendify-3e369',
    authDomain: 'spendify-3e369.firebaseapp.com',
    storageBucket: 'spendify-3e369.firebasestorage.app',
    measurementId: 'G-BXT32JBDR5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYq87Xwun2wnUl0U04gigvGc9x5bj5c7M',
    appId: '1:328568344086:android:c16d65a77d6be7811e2f37',
    messagingSenderId: '328568344086',
    projectId: 'spendify-3e369',
    storageBucket: 'spendify-3e369.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEQ1Ar8_jNhXrElJ4ZhjOzHCmXku4jftE',
    appId: '1:328568344086:ios:04949c46d07210161e2f37',
    messagingSenderId: '328568344086',
    projectId: 'spendify-3e369',
    storageBucket: 'spendify-3e369.firebasestorage.app',
    iosBundleId: 'com.example.spendify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAEQ1Ar8_jNhXrElJ4ZhjOzHCmXku4jftE',
    appId: '1:328568344086:ios:04949c46d07210161e2f37',
    messagingSenderId: '328568344086',
    projectId: 'spendify-3e369',
    storageBucket: 'spendify-3e369.firebasestorage.app',
    iosBundleId: 'com.example.spendify',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDshBys5XRmClOTIvSDXKOZl5864pQ64sg',
    appId: '1:328568344086:web:3d96f441bcfad2111e2f37',
    messagingSenderId: '328568344086',
    projectId: 'spendify-3e369',
    authDomain: 'spendify-3e369.firebaseapp.com',
    storageBucket: 'spendify-3e369.firebasestorage.app',
    measurementId: 'G-GRBGW0KS64',
  );
}
