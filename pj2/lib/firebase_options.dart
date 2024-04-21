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
    apiKey: 'AIzaSyAM6iRuL0hfoHMGVmJmLV17uoOfun6FObg',
    appId: '1:120126130569:web:51df867cb8c08798e07958',
    messagingSenderId: '120126130569',
    projectId: 'art-gallery-dfd6e',
    authDomain: 'art-gallery-dfd6e.firebaseapp.com',
    storageBucket: 'art-gallery-dfd6e.appspot.com',
    measurementId: 'G-HLBZ8GRBK2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9mWDu8oNecE2bZV5wWQt_8x9LoIJHFfM',
    appId: '1:120126130569:android:069dab597dde578be07958',
    messagingSenderId: '120126130569',
    projectId: 'art-gallery-dfd6e',
    storageBucket: 'art-gallery-dfd6e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJd7GVC0Plv9npwHJM4F6blwUgxjz7BGM',
    appId: '1:120126130569:ios:49a0a7f53a6db3b8e07958',
    messagingSenderId: '120126130569',
    projectId: 'art-gallery-dfd6e',
    storageBucket: 'art-gallery-dfd6e.appspot.com',
    iosBundleId: 'com.example.pj2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJd7GVC0Plv9npwHJM4F6blwUgxjz7BGM',
    appId: '1:120126130569:ios:49a0a7f53a6db3b8e07958',
    messagingSenderId: '120126130569',
    projectId: 'art-gallery-dfd6e',
    storageBucket: 'art-gallery-dfd6e.appspot.com',
    iosBundleId: 'com.example.pj2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAM6iRuL0hfoHMGVmJmLV17uoOfun6FObg',
    appId: '1:120126130569:web:1a4bf55a060acc0de07958',
    messagingSenderId: '120126130569',
    projectId: 'art-gallery-dfd6e',
    authDomain: 'art-gallery-dfd6e.firebaseapp.com',
    storageBucket: 'art-gallery-dfd6e.appspot.com',
    measurementId: 'G-XMFLPCJZ9J',
  );
}
