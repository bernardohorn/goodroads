import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../nucleo/injecao_dependencias/provedores_globais.dart';
import '../../dados/fontes_dados/autenticacao_local_fonte_impl.dart';
import '../../dados/fontes_dados/autenticacao_remota_fonte.dart';
import '../../dados/fontes_dados/autenticacao_remota_fonte_impl.dart';
import '../../dados/repositorios/autenticacao_repositorio_impl.dart';
import '../../dominio/casos_uso/entrar_caso_uso.dart';
import '../../dominio/casos_uso/registrar_caso_uso.dart';
import '../../dominio/entidades/usuario_entidade.dart';
import '../../dominio/repositorios/autenticacao_repositorio.dart';
import '../../../../compartilhado/modelos/resultado.dart';

/// Estado da sessão autenticada.
final sessaoAutenticadaProvider = StateProvider<bool>((ref) => false);

final autenticacaoRemotaFonteProvider = Provider<AutenticacaoRemotaFonte>(
  (ref) => AutenticacaoRemotaFonteImpl(ref.watch(dioProvider)),
);

final autenticacaoLocalFonteProvider = Provider<AutenticacaoLocalFonteImpl>(
  (ref) => AutenticacaoLocalFonteImpl(
    ref.watch(armazenamentoLocalServicoProvider),
  ),
);

final autenticacaoRepositorioProvider = Provider<AutenticacaoRepositorio>(
  (ref) => AutenticacaoRepositorioImpl(
    remota: ref.watch(autenticacaoRemotaFonteProvider),
    local: ref.watch(autenticacaoLocalFonteProvider),
  ),
);

final entrarCasoUsoProvider = Provider<EntrarCasoUso>(
  (ref) => EntrarCasoUso(ref.watch(autenticacaoRepositorioProvider)),
);

final registrarCasoUsoProvider = Provider<RegistrarCasoUso>(
  (ref) => RegistrarCasoUso(ref.watch(autenticacaoRepositorioProvider)),
);

/// Dados extras do perfil armazenados localmente (CPF, data de nascimento, telefone).
/// **Nota:** o backend ainda não persiste CPF/data — ver banco.sql.
final perfilLocalProvider = FutureProvider<(String?, String?, String?)>((ref) async {
  final repo = ref.watch(autenticacaoRepositorioProvider)
      as AutenticacaoRepositorioImpl;
  final cpf = await repo.obterCpfLocal();
  final data = await repo.obterDataNascimentoLocal();
  final telefone = await repo.obterTelefoneLocal();
  return (cpf, data, telefone);
});

/// Controlador de autenticação.
final autenticacaoControladorProvider =
    NotifierProvider<AutenticacaoControlador, AsyncValue<UsuarioEntidade?>>(
  AutenticacaoControlador.new,
);

class AutenticacaoControlador extends Notifier<AsyncValue<UsuarioEntidade?>> {
  @override
  AsyncValue<UsuarioEntidade?> build() {
    _restaurarSessao();
    return const AsyncValue.loading();
  }

  Future<void> _restaurarSessao() async {
    final usuario =
        await ref.read(autenticacaoRepositorioProvider).obterUsuarioAtual();
    if (usuario != null) {
      ref.read(sessaoAutenticadaProvider.notifier).state = true;
      state = AsyncValue.data(usuario);
    } else {
      ref.read(sessaoAutenticadaProvider.notifier).state = false;
      state = const AsyncValue.data(null);
    }
  }

  Future<void> entrar({required String email, required String senha}) async {
    state = const AsyncValue.loading();
    final casoUso = ref.read(entrarCasoUsoProvider);
    final resultado = await casoUso.executar(email: email, senha: senha);

    switch (resultado) {
      case Sucesso(:final dados):
        ref.read(sessaoAutenticadaProvider.notifier).state = true;
        state = AsyncValue.data(dados);
      case Erro(:final falha):
        ref.read(sessaoAutenticadaProvider.notifier).state = false;
        state = AsyncValue.error(falha.mensagem, StackTrace.empty);
    }
  }

  Future<void> registrar({
    required String nome,
    required String email,
    required String senha,
    String? telefone,
    String? cpf,
    String? dataNascimento,
  }) async {
    state = const AsyncValue.loading();
    final repositorio = ref.read(autenticacaoRepositorioProvider);
    final resultado = await repositorio.registrar(
      nome: nome,
      email: email,
      senha: senha,
      telefone: telefone,
      cpf: cpf,
      dataNascimento: dataNascimento,
    );

    switch (resultado) {
      case Sucesso(:final dados):
        ref.read(sessaoAutenticadaProvider.notifier).state = true;
        state = AsyncValue.data(dados);
      case Erro(:final falha):
        ref.read(sessaoAutenticadaProvider.notifier).state = false;
        state = AsyncValue.error(falha.mensagem, StackTrace.empty);
    }
  }

  Future<void> sair() async {
    await ref.read(autenticacaoRepositorioProvider).sair();
    ref.read(sessaoAutenticadaProvider.notifier).state = false;
    state = const AsyncValue.data(null);
  }
}

/// Verifica se o usuário tem perfil administrativo.
bool usuarioEhAdmin(UsuarioEntidade? usuario) =>
    usuario?.papel == 'admin' || usuario?.papel == 'prefeitura';
