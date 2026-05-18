// ignore_for_file: lines_longer_than_80_chars
// Substitua este arquivo executando:
//   dart pub global activate flutterfire_cli
//   dart run flutterfire_cli:flutterfire configure
//
// Ou preencha manualmente com os dados do Console Firebase.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Opções do Firebase — placeholders até configuração real.
abstract final class OpcoesFirebase {
  static FirebaseOptions get atuais {
    if (kIsWeb) return _web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.iOS:
        return _ios;
      case TargetPlatform.macOS:
        return _macos;
      default:
        return _web;
    }
  }

  static const FirebaseOptions _web = FirebaseOptions(
    apiKey: 'SUBSTITUA_API_KEY_WEB',
    appId: 'SUBSTITUA_APP_ID_WEB',
    messagingSenderId: 'SUBSTITUA_SENDER_ID',
    projectId: 'SUBSTITUA_PROJECT_ID',
    authDomain: 'SUBSTITUA_AUTH_DOMAIN',
    storageBucket: 'SUBSTITUA_STORAGE_BUCKET',
  );

  static const FirebaseOptions _android = FirebaseOptions(
    apiKey: 'SUBSTITUA_API_KEY_ANDROID',
    appId: 'SUBSTITUA_APP_ID_ANDROID',
    messagingSenderId: 'SUBSTITUA_SENDER_ID',
    projectId: 'SUBSTITUA_PROJECT_ID',
    storageBucket: 'SUBSTITUA_STORAGE_BUCKET',
  );

  static const FirebaseOptions _ios = FirebaseOptions(
    apiKey: 'SUBSTITUA_API_KEY_IOS',
    appId: 'SUBSTITUA_APP_ID_IOS',
    messagingSenderId: 'SUBSTITUA_SENDER_ID',
    projectId: 'SUBSTITUA_PROJECT_ID',
    storageBucket: 'SUBSTITUA_STORAGE_BUCKET',
    iosBundleId: 'com.grb.goodroads',
  );

  static const FirebaseOptions _macos = FirebaseOptions(
    apiKey: 'SUBSTITUA_API_KEY_MACOS',
    appId: 'SUBSTITUA_APP_ID_MACOS',
    messagingSenderId: 'SUBSTITUA_SENDER_ID',
    projectId: 'SUBSTITUA_PROJECT_ID',
    storageBucket: 'SUBSTITUA_STORAGE_BUCKET',
    iosBundleId: 'com.grb.goodroads',
  );

  /// Indica se as chaves ainda são placeholders.
  static bool get saoPlaceholders =>
      _android.apiKey.startsWith('SUBSTITUA');
}
