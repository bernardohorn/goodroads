/// Contrato para upload e cache de imagens (implementação futura).
abstract interface class ArmazenamentoImagemServico {
  Future<String> enviarImagem(String caminhoLocal);

  Future<void> excluirImagem(String url);

  Future<String?> obterUrlCache(String identificador);
}
