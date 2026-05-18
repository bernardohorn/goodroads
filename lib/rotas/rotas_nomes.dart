/// Nomes e caminhos das rotas do aplicativo.
abstract final class RotasNomes {
  // Autenticação
  static const String login = '/login';
  static const String registro = '/registro';

  // Mobile — shell principal
  static const String inicio = '/inicio';
  static const String ocorrencias = '/ocorrencias';
  static const String mapas = '/mapas';
  static const String perfil = '/perfil';

  // Sub-rotas
  static const String notificacoes = '/notificacoes';
  static const String configuracoes = '/configuracoes';
  static const String detalheOcorrencia = '/ocorrencias/:id';

  // Painel administrativo
  static const String administrativo = '/administrativo';
  static const String administrativoPainel = '/administrativo/painel';
  static const String administrativoOcorrencias = '/administrativo/ocorrencias';
  static const String administrativoUsuarios = '/administrativo/usuarios';
}
