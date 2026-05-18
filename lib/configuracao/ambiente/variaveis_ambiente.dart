import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Carrega e expõe variáveis de ambiente.
abstract final class VariaveisAmbiente {
  static Future<void> carregar() async {
    await dotenv.load(fileName: 'assets/configuracao/ambiente.padrao.env');

    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // Opcional: adicione `.env` em pubspec.yaml > assets após criar o arquivo.
    }
  }

  static String get urlBaseApi =>
      dotenv.env['URL_BASE_API'] ?? 'https://api.goodroads.grb.local';

  static String get googleMapsApiKey =>
      dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  static String get cpfCnpjApiUrl =>
      dotenv.env['CPF_CNPJ_API_URL'] ?? '';

  static String get cpfCnpjApiToken =>
      dotenv.env['CPF_CNPJ_API_TOKEN'] ?? '';

  static bool get firebaseHabilitado =>
      dotenv.env['FIREBASE_HABILITADO']?.toLowerCase() == 'true';

  static bool get googleMapsConfigurado => googleMapsApiKey.isNotEmpty;
}
