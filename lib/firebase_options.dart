// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPSpQhlZj6MJnGfiAxyRN-Oh2syJx5mqQ',
    appId: '1:765810387470:android:93cde6dff58b785db7ea5f',
    messagingSenderId: '765810387470',
    projectId: 'mychatapp-acaee',
    storageBucket: 'mychatapp-acaee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNj_nhbJf7tIPMZzfY7sbr6-A0ZsvACNA',
    appId: '1:765810387470:ios:0978caa56b5a456bb7ea5f',
    messagingSenderId: '765810387470',
    projectId: 'mychatapp-acaee',
    storageBucket: 'mychatapp-acaee.appspot.com',
    androidClientId: '765810387470-s8gv728od40ehlkh8nu9mt6bm5k19j54.apps.googleusercontent.com',
    iosClientId: '765810387470-sme9vesk0l6u0e41rsb1kp7bj6mpvgpr.apps.googleusercontent.com',
    iosBundleId: 'com.example.weChat',
  );
}
