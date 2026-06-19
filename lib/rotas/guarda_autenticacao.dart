import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../funcionalidades/autenticacao/apresentacao/providers/autenticacao_provider.dart';
import 'rotas_nomes.dart';

/// Lógica de redirecionamento baseada no estado de autenticação.
String? guardaAutenticacao(Ref ref, String localizacao) {
  final autenticado = ref.read(sessaoAutenticadaProvider);
  final usuario = ref.read(autenticacaoControladorProvider).valueOrNull;

  final rotasPublicas = [RotasNomes.login, RotasNomes.registro];
  final ehRotaPublica = rotasPublicas.contains(localizacao);
  final ehRotaAdmin = localizacao.startsWith(RotasNomes.administrativo);

  if (!autenticado && !ehRotaPublica) {
    return RotasNomes.login;
  }

  if (autenticado && ehRotaPublica) {
    return RotasNomes.inicio;
  }

  if (autenticado && ehRotaAdmin && !usuarioEhAdmin(usuario)) {
    return RotasNomes.inicio;
  }

  return null;
}
