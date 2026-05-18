/// Representa uma falha de domínio ou infraestrutura.
sealed class Falha {
  const Falha(this.mensagem);

  final String mensagem;
}

final class FalhaServidor extends Falha {
  const FalhaServidor([super.mensagem = 'Erro no servidor. Tente novamente.']);
}

final class FalhaRede extends Falha {
  const FalhaRede([super.mensagem = 'Sem conexão com a internet.']);
}

final class FalhaAutenticacao extends Falha {
  const FalhaAutenticacao([super.mensagem = 'Credenciais inválidas.']);
}

final class FalhaDesconhecida extends Falha {
  const FalhaDesconhecida([super.mensagem = 'Ocorreu um erro inesperado.']);
}
