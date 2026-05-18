import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dados/repositorios/autenticacao_repositorio_impl.dart';
import '../../dominio/casos_uso/entrar_caso_uso.dart';
import '../../dominio/casos_uso/registrar_caso_uso.dart';
import '../../dominio/entidades/usuario_entidade.dart';
import '../../dominio/repositorios/autenticacao_repositorio.dart';
import '../../../../compartilhado/modelos/resultado.dart';

/// Estado da sessão autenticada (stub — substituir por stream real).
final sessaoAutenticadaProvider = StateProvider<bool>((ref) => false);

final autenticacaoRepositorioProvider = Provider<AutenticacaoRepositorio>(
  (ref) => AutenticacaoRepositorioImpl(
    remota: AutenticacaoRemotaFonteStub(),
    local: AutenticacaoLocalFonteStub(),
  ),
);

final entrarCasoUsoProvider = Provider<EntrarCasoUso>(
  (ref) => EntrarCasoUso(ref.watch(autenticacaoRepositorioProvider)),
);

final registrarCasoUsoProvider = Provider<RegistrarCasoUso>(
  (ref) => RegistrarCasoUso(ref.watch(autenticacaoRepositorioProvider)),
);

/// Controlador de autenticação.
final autenticacaoControladorProvider =
    NotifierProvider<AutenticacaoControlador, AsyncValue<UsuarioEntidade?>>(
  AutenticacaoControlador.new,
);

class AutenticacaoControlador extends Notifier<AsyncValue<UsuarioEntidade?>> {
  @override
  AsyncValue<UsuarioEntidade?> build() => const AsyncValue.data(null);

  Future<void> entrar({required String email, required String senha}) async {
    state = const AsyncValue.loading();
    final casoUso = ref.read(entrarCasoUsoProvider);
    final resultado = await casoUso.executar(email: email, senha: senha);

    switch (resultado) {
      case Sucesso(:final dados):
        ref.read(sessaoAutenticadaProvider.notifier).state = true;
        state = AsyncValue.data(dados);
      case Erro():
        ref.read(sessaoAutenticadaProvider.notifier).state = false;
        state = const AsyncValue.error('Falha ao entrar', StackTrace.empty);
    }
  }

  Future<void> sair() async {
    await ref.read(autenticacaoRepositorioProvider).sair();
    ref.read(sessaoAutenticadaProvider.notifier).state = false;
    state = const AsyncValue.data(null);
  }
}
