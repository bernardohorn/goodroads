import '../../nucleo/erros/falha.dart';

/// Encapsula sucesso ou falha de operações assíncronas.
sealed class Resultado<T> {
  const Resultado();
}

final class Sucesso<T> extends Resultado<T> {
  const Sucesso(this.dados);

  final T dados;
}

final class Erro<T> extends Resultado<T> {
  const Erro(this.falha);

  final Falha falha;
}
