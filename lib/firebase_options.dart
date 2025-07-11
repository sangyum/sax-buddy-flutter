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
    apiKey: 'AIzaSyD4skS0Hx2ThSC0_jgXVtxdVFRV97ZE5kE',
    appId: '1:597882776569:android:059cdceba1b2c778406b28',
    messagingSenderId: '597882776569',
    projectId: 'sax-buddy-ed0de',
    storageBucket: 'sax-buddy-ed0de.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBWxJbbyBt64C0yyQxC1ruIGVhzrO_6iO0',
    appId: '1:597882776569:ios:da6d96d68848bb85406b28',
    messagingSenderId: '597882776569',
    projectId: 'sax-buddy-ed0de',
    storageBucket: 'sax-buddy-ed0de.firebasestorage.app',
    androidClientId: '597882776569-qoqv8pqrdlc7tsd5smkrrjpvnildgh31.apps.googleusercontent.com',
    iosClientId: '597882776569-mhk14n1n6okuc6a6oitn032hmag5ddgq.apps.googleusercontent.com',
    iosBundleId: 'com.example.saxBuddy',
  );
}
