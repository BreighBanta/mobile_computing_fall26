import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('DefaultFirebaseOptions have not been configured for web.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError('Android configuration not provided.');
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios; // Reusing iOS options for macOS runner
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyATIBrUCGAlABQJw3ZamKidCeGAqU4SWzs',
    appId: '1:27259131045:ios:55cfd575ef97263c76e94c',
    messagingSenderId: '27259131045',
    projectId: 'cloud-notes-692a8',
    storageBucket: 'cloud-notes-692a8.firebasestorage.app',
    iosBundleId: 'com.example.lab11',
  );
}