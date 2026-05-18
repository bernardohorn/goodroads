/// Constantes para integração futura com API ou Firebase.
abstract final class ConstantesApi {
  static const String urlBase = String.fromEnvironment(
    'URL_BASE_API',
    defaultValue: 'https://api.goodroads.grb.local',
  );

  static const Duration tempoLimiteRequisicao = Duration(seconds: 30);
}
