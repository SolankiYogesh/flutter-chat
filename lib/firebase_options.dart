// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9_9dfVQy-AE4MxpeX29Z0zi3mgCrv1sU',
    appId: '1:344827798495:android:a2d0f90010311055d11a6a',
    messagingSenderId: '344827798495',
    projectId: 'chatapp-e88e6',
    databaseURL: 'https://chatapp-e88e6-default-rtdb.firebaseio.com',
    storageBucket: 'chatapp-e88e6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAGoZAqCXThWt6eKOmZorH71T1GP3_urA4',
    appId: '1:344827798495:ios:f30126698c8e1b2bd11a6a',
    messagingSenderId: '344827798495',
    projectId: 'chatapp-e88e6',
    databaseURL: 'https://chatapp-e88e6-default-rtdb.firebaseio.com',
    storageBucket: 'chatapp-e88e6.appspot.com',
    iosBundleId: 'com.example.folderStucture',
  );

}