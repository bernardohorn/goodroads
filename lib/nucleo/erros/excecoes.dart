/// Exceções de camada de dados.
class ExcecaoServidor implements Exception {
  const ExcecaoServidor([this.mensagem = 'Erro no servidor']);

  final String mensagem;
}

class ExcecaoCache implements Exception {
  const ExcecaoCache([this.mensagem = 'Erro ao acessar armazenamento local']);

  final String mensagem;
}
