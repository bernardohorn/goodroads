import '../../configuracao/ambiente/variaveis_ambiente.dart';

/// Constantes para integração com API REST.
abstract final class ConstantesApi {
  static String get urlBase => VariaveisAmbiente.urlBaseApi;

  static const Duration tempoLimiteRequisicao = Duration(seconds: 30);

  static const String cabecalhoAutorizacao = 'Authorization';
}
