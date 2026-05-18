/// Validações reutilizáveis de formulários.
abstract final class Validador {
  static String? email(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o e-mail';
    }
    final padrao = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!padrao.hasMatch(valor.trim())) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? obrigatorio(String? valor, {String campo = 'Campo'}) {
    if (valor == null || valor.trim().isEmpty) {
      return '$campo é obrigatório';
    }
    return null;
  }

  static String? senha(String? valor) {
    if (valor == null || valor.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
}
