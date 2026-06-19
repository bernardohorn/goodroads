/// Formatação e validação de CPF brasileiro.
abstract final class FormatadorCpf {
  static String aplicarMascara(String valor) {
    final digitos = valor.replaceAll(RegExp(r'\D'), '');
    if (digitos.isEmpty) return '';
    if (digitos.length <= 3) return digitos;
    if (digitos.length <= 6) {
      return '${digitos.substring(0, 3)}.${digitos.substring(3)}';
    }
    if (digitos.length <= 9) {
      return '${digitos.substring(0, 3)}.${digitos.substring(3, 6)}.'
          '${digitos.substring(6)}';
    }
    return '${digitos.substring(0, 3)}.${digitos.substring(3, 6)}.'
        '${digitos.substring(6, 9)}-${digitos.substring(9, digitos.length.clamp(0, 11))}';
  }

  static String somenteDigitos(String valor) =>
      valor.replaceAll(RegExp(r'\D'), '');
}
