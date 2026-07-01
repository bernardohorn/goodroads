import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Carrega e expõe variáveis de ambiente do aplicativo.
///
/// Estratégia de carregamento:
/// 1. Carrega `assets/configuracao/ambiente.padrao.env` (valores padrão, versionado)
/// 2. Tenta carregar `.env` na raiz do projeto (override local, NÃO versionado)
///    — crie este arquivo a partir de `.env.example` e preencha os valores reais.
abstract final class VariaveisAmbiente {
  static Future<void> carregar() async {
    await dotenv.load(fileName: 'assets/configuracao/ambiente.padrao.env');

    try {
      await dotenv.load(fileName: '.env', mergeWith: dotenv.env);
    } catch (_) {
      // Arquivo .env opcional — crie a partir de .env.example para dev local.
    }
  }

  static String get urlBaseApi {
    const urlBaseApiDefine = String.fromEnvironment('URL_BASE_API');
    if (urlBaseApiDefine.isNotEmpty) return urlBaseApiDefine;
    return dotenv.env['URL_BASE_API'] ?? 'http://localhost:3001/api';
  }

  static String get googleMapsApiKey =>
      dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  static String get cpfCnpjApiUrl => dotenv.env['CPF_CNPJ_API_URL'] ?? '';

  static String get cpfCnpjApiToken => dotenv.env['CPF_CNPJ_API_TOKEN'] ?? '';

  /// Firebase habilitado quando a env var for `true` ou em dev com credenciais.
  static bool get firebaseHabilitado {
    final flag = dotenv.env['FIREBASE_HABILITADO']?.toLowerCase();
    if (flag == 'false') return false;
    if (flag == 'true') return true;
    return modoDesenvolvimento && firebaseConfigurado;
  }

  static String get firebaseApiKey =>
      dotenv.env['FIREBASE_API_KEY'] ?? '';

  static String get firebaseAppIdAndroid =>
      dotenv.env['FIREBASE_APP_ID_ANDROID'] ?? '';

  static String get firebaseAppIdIos =>
      dotenv.env['FIREBASE_APP_ID_IOS'] ?? '';

  static String get firebaseAppIdWeb =>
      dotenv.env['FIREBASE_APP_ID_WEB'] ?? '';

  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';

  static String get firebaseMessagingSenderId =>
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';

  static String get firebaseStorageBucket =>
      dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';

  static String get firebaseAuthDomain =>
      dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '';

  /// Credenciais Firebase preenchidas e válidas (não placeholders).
  static bool get firebaseConfigurado {
    bool valido(String valor) =>
        valor.isNotEmpty && !valor.startsWith('SUBSTITUA');

    return valido(firebaseApiKey) &&
        valido(firebaseProjectId) &&
        valido(firebaseMessagingSenderId) &&
        valido(firebaseAppIdWeb);
  }

  /// Google Maps configurado quando a API key não estiver vazia.
  static bool get googleMapsConfigurado => googleMapsApiKey.isNotEmpty;

  /// Indica ambiente de desenvolvimento (baseado na URL da API).
  static bool get modoDesenvolvimento =>
      urlBaseApi.contains('localhost') || urlBaseApi.contains('127.0.0.1');
}
