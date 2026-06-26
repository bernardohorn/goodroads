// ignore_for_file: lines_longer_than_80_chars
// Configure via `.env` (variáveis FIREBASE_*) ou execute:
//   dart run flutterfire_cli:flutterfire configure

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import '../ambiente/variaveis_ambiente.dart';

/// Opções do Firebase por plataforma, lidas das variáveis de ambiente.
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
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return _web;
      default:
        return _web;
    }
  }

  static FirebaseOptions get _web => FirebaseOptions(
        apiKey: VariaveisAmbiente.firebaseApiKey,
        appId: VariaveisAmbiente.firebaseAppIdWeb,
        messagingSenderId: VariaveisAmbiente.firebaseMessagingSenderId,
        projectId: VariaveisAmbiente.firebaseProjectId,
        authDomain: VariaveisAmbiente.firebaseAuthDomain.isNotEmpty
            ? VariaveisAmbiente.firebaseAuthDomain
            : '${VariaveisAmbiente.firebaseProjectId}.firebaseapp.com',
        storageBucket: VariaveisAmbiente.firebaseStorageBucket.isNotEmpty
            ? VariaveisAmbiente.firebaseStorageBucket
            : '${VariaveisAmbiente.firebaseProjectId}.appspot.com',
      );

  static FirebaseOptions get _android => FirebaseOptions(
        apiKey: VariaveisAmbiente.firebaseApiKey,
        appId: VariaveisAmbiente.firebaseAppIdAndroid.isNotEmpty
            ? VariaveisAmbiente.firebaseAppIdAndroid
            : VariaveisAmbiente.firebaseAppIdWeb,
        messagingSenderId: VariaveisAmbiente.firebaseMessagingSenderId,
        projectId: VariaveisAmbiente.firebaseProjectId,
        storageBucket: VariaveisAmbiente.firebaseStorageBucket.isNotEmpty
            ? VariaveisAmbiente.firebaseStorageBucket
            : '${VariaveisAmbiente.firebaseProjectId}.appspot.com',
      );

  static FirebaseOptions get _ios => FirebaseOptions(
        apiKey: VariaveisAmbiente.firebaseApiKey,
        appId: VariaveisAmbiente.firebaseAppIdIos.isNotEmpty
            ? VariaveisAmbiente.firebaseAppIdIos
            : VariaveisAmbiente.firebaseAppIdWeb,
        messagingSenderId: VariaveisAmbiente.firebaseMessagingSenderId,
        projectId: VariaveisAmbiente.firebaseProjectId,
        storageBucket: VariaveisAmbiente.firebaseStorageBucket.isNotEmpty
            ? VariaveisAmbiente.firebaseStorageBucket
            : '${VariaveisAmbiente.firebaseProjectId}.appspot.com',
        iosBundleId: 'com.grb.goodroads',
      );

  static FirebaseOptions get _macos => FirebaseOptions(
        apiKey: VariaveisAmbiente.firebaseApiKey,
        appId: VariaveisAmbiente.firebaseAppIdIos.isNotEmpty
            ? VariaveisAmbiente.firebaseAppIdIos
            : VariaveisAmbiente.firebaseAppIdWeb,
        messagingSenderId: VariaveisAmbiente.firebaseMessagingSenderId,
        projectId: VariaveisAmbiente.firebaseProjectId,
        storageBucket: VariaveisAmbiente.firebaseStorageBucket.isNotEmpty
            ? VariaveisAmbiente.firebaseStorageBucket
            : '${VariaveisAmbiente.firebaseProjectId}.appspot.com',
        iosBundleId: 'com.grb.goodroads',
      );

  /// Retorna `true` enquanto as credenciais não estiverem configuradas.
  static bool get saoPlaceholders => !VariaveisAmbiente.firebaseConfigurado;
}
