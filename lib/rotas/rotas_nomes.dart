// lib/rotas/rotas_nomes.dart  — VERSÃO ATUALIZADA
// Adicione a rota novaOcorrencia

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
  static const String novaOcorrencia = '/ocorrencias/nova';
  static const String historico = '/historico';

  // Painel administrativo
  static const String administrativo = '/administrativo';
  static const String administrativoPainel = '/administrativo/painel';
  static const String administrativoOcorrencias = '/administrativo/ocorrencias';
  static const String administrativoUsuarios = '/administrativo/usuarios';
}
