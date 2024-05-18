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
    apiKey: 'AIzaSyBzPieAotbl-6hU-THzqRqN9lcflXrwo8A',
    appId: '1:149837919886:web:104f93f8d06263843abbdf',
    messagingSenderId: '149837919886',
    projectId: 'dplm-94d38',
    authDomain: 'dplm-94d38.firebaseapp.com',
    storageBucket: 'dplm-94d38.appspot.com',
    measurementId: 'G-3PQWVCBSEB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCVUiTZKSDwGuxPLoEhfH0gQl1GifqaHKI',
    appId: '1:149837919886:android:46a7c73bacb12a7c3abbdf',
    messagingSenderId: '149837919886',
    projectId: 'dplm-94d38',
    storageBucket: 'dplm-94d38.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9N_QfKMh5FdaXq-60ve-k6uVw9VDRmwE',
    appId: '1:149837919886:ios:0148c0d8c9c6d36a3abbdf',
    messagingSenderId: '149837919886',
    projectId: 'dplm-94d38',
    storageBucket: 'dplm-94d38.appspot.com',
    iosBundleId: 'com.example.demogp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9N_QfKMh5FdaXq-60ve-k6uVw9VDRmwE',
    appId: '1:149837919886:ios:0148c0d8c9c6d36a3abbdf',
    messagingSenderId: '149837919886',
    projectId: 'dplm-94d38',
    storageBucket: 'dplm-94d38.appspot.com',
    iosBundleId: 'com.example.demogp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBzPieAotbl-6hU-THzqRqN9lcflXrwo8A',
    appId: '1:149837919886:web:5a741e9b9c807fa03abbdf',
    messagingSenderId: '149837919886',
    projectId: 'dplm-94d38',
    authDomain: 'dplm-94d38.firebaseapp.com',
    storageBucket: 'dplm-94d38.appspot.com',
    measurementId: 'G-89V72JC4QT',
  );
}
