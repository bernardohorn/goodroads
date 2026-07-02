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

final class FalhaTokenExpirado extends Falha {
  const FalhaTokenExpirado(
      [super.mensagem = 'Sua sessão expirou. Faça login novamente.']);
}

final class FalhaEmailJaCadastrado extends Falha {
  const FalhaEmailJaCadastrado(
      [super.mensagem = 'Este e-mail já está cadastrado.']);
}

final class FalhaSenhaFraca extends Falha {
  const FalhaSenhaFraca(
      [super.mensagem = 'Senha muito fraca. Use pelo menos 6 caracteres.']);
}

final class FalhaEmailInvalido extends Falha {
  const FalhaEmailInvalido(
      [super.mensagem = 'E-mail inválido. Verifique o endereço informado.']);
}

final class FalhaTimeout extends Falha {
  const FalhaTimeout(
      [super.mensagem = 'Tempo esgotado. Verifique sua conexão e tente novamente.']);
}

final class FalhaDesconhecida extends Falha {
  const FalhaDesconhecida([super.mensagem = 'Ocorreu um erro inesperado.']);
}

final class FalhaNaoAutorizado extends Falha {
  const FalhaNaoAutorizado(
      [super.mensagem = 'Você não tem permissão para esta ação.']);
}
