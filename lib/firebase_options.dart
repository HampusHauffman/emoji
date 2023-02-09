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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAmm_ZRBltUJPkkm81Iu0SjNQCv3K3J1C0',
    appId: '1:213704231787:web:7fa64e364aa4bf1cf09a2e',
    messagingSenderId: '213704231787',
    projectId: 'emoji-4cbcb',
    authDomain: 'emoji-4cbcb.firebaseapp.com',
    storageBucket: 'emoji-4cbcb.appspot.com',
    measurementId: 'G-Y6ETJ7JRH1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWM1OwbDK8MSe1fqDdKOVRbQyHQgpzv4k',
    appId: '1:213704231787:android:9cd21f51b4ede1aaf09a2e',
    messagingSenderId: '213704231787',
    projectId: 'emoji-4cbcb',
    storageBucket: 'emoji-4cbcb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0DtatxkUty6OJl8hwztJAJPhN0P-GhWQ',
    appId: '1:213704231787:ios:8d3e6d7bb61632def09a2e',
    messagingSenderId: '213704231787',
    projectId: 'emoji-4cbcb',
    storageBucket: 'emoji-4cbcb.appspot.com',
    iosClientId: '213704231787-jnrae12q749mgfrtq6lg9uii2373nd8o.apps.googleusercontent.com',
    iosBundleId: 'com.emojicount.emojiCount',
  );
}