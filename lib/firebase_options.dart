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

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBTYXqA8kp8ntkiRUlw86ZW3jREHtCIdIM',
    appId: '1:965369209410:ios:1f49f227e4be6681e703db',
    messagingSenderId: '965369209410',
    projectId: 'reddit-a0608',
    storageBucket: 'reddit-a0608.firebasestorage.app',
    iosBundleId: 'com.example.myFlutterApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBTYXqA8kp8ntkiRUlw86ZW3jREHtCIdIM',
    appId: '1:965369209410:ios:1f49f227e4be6681e703db',
    messagingSenderId: '965369209410',
    projectId: 'reddit-a0608',
    storageBucket: 'reddit-a0608.firebasestorage.app',
    iosBundleId: 'com.example.myFlutterApp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBTF2WdBy3Y2K03rXtVQsBGKL4dsxBib3s',
    appId: '1:965369209410:web:ee8c1888e4c25a8fe703db',
    messagingSenderId: '965369209410',
    projectId: 'reddit-a0608',
    authDomain: 'reddit-a0608.firebaseapp.com',
    storageBucket: 'reddit-a0608.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACi24YLoo8f49CMnSApGEq536L7wfdPV8',
    appId: '1:965369209410:android:6ae0681ed2b368bce703db',
    messagingSenderId: '965369209410',
    projectId: 'reddit-a0608',
    storageBucket: 'reddit-a0608.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBTF2WdBy3Y2K03rXtVQsBGKL4dsxBib3s',
    appId: '1:965369209410:web:5b31a8c1c4da0fb3e703db',
    messagingSenderId: '965369209410',
    projectId: 'reddit-a0608',
    authDomain: 'reddit-a0608.firebaseapp.com',
    storageBucket: 'reddit-a0608.firebasestorage.app',
  );

}