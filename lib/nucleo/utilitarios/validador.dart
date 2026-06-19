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

  static String? confirmarSenha(String? valor, String senhaOriginal) {
    if (valor == null || valor.isEmpty) {
      return 'Confirme a senha';
    }
    if (valor != senhaOriginal) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  static String? cpf(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o CPF';
    }
    final digitos = valor.replaceAll(RegExp(r'\D'), '');
    if (digitos.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    if (RegExp(r'^(\d)\1{10}$').hasMatch(digitos)) {
      return 'CPF inválido';
    }

    int calcularDigito(List<int> base, int fatorInicial) {
      var soma = 0;
      for (var i = 0; i < base.length; i++) {
        soma += base[i] * (fatorInicial - i);
      }
      final resto = soma % 11;
      return resto < 2 ? 0 : 11 - resto;
    }

    final numeros = digitos.split('').map(int.parse).toList();
    final digito1 = calcularDigito(numeros.sublist(0, 9), 10);
    final digito2 = calcularDigito(numeros.sublist(0, 10), 11);

    if (digito1 != numeros[9] || digito2 != numeros[10]) {
      return 'CPF inválido';
    }
    return null;
  }

  static String? dataNascimento(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe a data de nascimento';
    }
    final partes = valor.split('/');
    if (partes.length != 3) return 'Use o formato dd/mm/aaaa';
    final dia = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    final ano = int.tryParse(partes[2]);
    if (dia == null || mes == null || ano == null) {
      return 'Data inválida';
    }
    final data = DateTime(ano, mes, dia);
    if (data.day != dia || data.month != mes || data.year != ano) {
      return 'Data inválida';
    }
    if (data.isAfter(DateTime.now())) {
      return 'Data não pode ser futura';
    }
    return null;
  }
}
