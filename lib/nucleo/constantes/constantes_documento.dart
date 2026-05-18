import '../../configuracao/ambiente/variaveis_ambiente.dart';

/// Constantes da API de consulta CPF/CNPJ.
abstract final class ConstantesDocumento {
  static String get urlBase => VariaveisAmbiente.cpfCnpjApiUrl;

  static String get token => VariaveisAmbiente.cpfCnpjApiToken;

  static const String caminhoCpf = '/cpf';
  static const String caminhoCnpj = '/cnpj';
}
