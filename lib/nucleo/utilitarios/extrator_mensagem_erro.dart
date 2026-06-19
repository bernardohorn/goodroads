import '../erros/falha.dart';

/// Extrai mensagem amigável para exibição ao usuário (sem stack trace).
String extrairMensagemErro(Object erro) {
  if (erro is Falha) return erro.mensagem;

  final texto = erro.toString();
  const prefixo = 'Exception: ';
  if (texto.startsWith(prefixo)) {
    return texto.substring(prefixo.length);
  }

  return texto;
}
