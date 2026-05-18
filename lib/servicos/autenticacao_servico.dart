/// Contrato do serviço de autenticação (Firebase / API — implementação futura).
abstract interface class AutenticacaoServico {
  Future<String?> obterTokenAtual();

  Future<void> encerrarSessao();

  Stream<bool> observarSessaoAtiva();
}
