import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../../../../compartilhado/modelos/resultado.dart';
import '../../../../nucleo/injecao_dependencias/provedores_globais.dart';
import '../../../../nucleo/utilitarios/gerador_id.dart';
import '../../dados/fontes_dados/ocorrencias_remota_fonte.dart';
import '../../dados/repositorios/ocorrencias_repositorio_impl.dart';
import '../../dominio/casos_uso/listar_ocorrencias_caso_uso.dart';
import '../../dominio/entidades/ocorrencia_entidade.dart';
import '../../dominio/repositorios/ocorrencias_repositorio.dart';

// ---------------------------------------------------------------------------
// Fonte + Repositório
// ---------------------------------------------------------------------------

final ocorrenciasRemotaFonteProvider =
    Provider<OcorrenciasRemotaFonte>((ref) {
  return OcorrenciasRemotaFonteImpl(ref.watch(dioProvider));
});

final ocorrenciasRepositorioProvider = Provider<OcorrenciasRepositorio>(
  (ref) => OcorrenciasRepositorioImpl(
    remota: ref.watch(ocorrenciasRemotaFonteProvider),
  ),
);

// ---------------------------------------------------------------------------
// Casos de uso
// ---------------------------------------------------------------------------

final listarOcorrenciasCasoUsoProvider = Provider<ListarOcorrenciasCasoUso>(
  (ref) => ListarOcorrenciasCasoUso(ref.watch(ocorrenciasRepositorioProvider)),
);

// ---------------------------------------------------------------------------
// FutureProvider — lista paginada
// ---------------------------------------------------------------------------

final ocorrenciasListaProvider =
    FutureProvider<List<OcorrenciaEntidade>>((ref) async {
  final casoUso = ref.watch(listarOcorrenciasCasoUsoProvider);
  final resultado = await casoUso.executar();
  return switch (resultado) {
    Sucesso(:final dados) => dados,
    Erro() => [],
  };
});

// ---------------------------------------------------------------------------
// Notifier — detalhe de uma ocorrência
// ---------------------------------------------------------------------------

final ocorrenciaDetalheProvider =
    FutureProvider.family<OcorrenciaEntidade?, String>((ref, id) async {
  final repositorio = ref.watch(ocorrenciasRepositorioProvider);
  final resultado = await repositorio.obterPorId(id);
  return switch (resultado) {
    Sucesso(:final dados) => dados,
    Erro() => null,
  };
});

// ---------------------------------------------------------------------------
// Notifier — formulário de nova ocorrência
// ---------------------------------------------------------------------------

class NovaOcorrenciaState {
  const NovaOcorrenciaState({
    this.carregando = false,
    this.erro,
    this.sucesso = false,
  });

  final bool carregando;
  final String? erro;
  final bool sucesso;

  NovaOcorrenciaState copyWith({
    bool? carregando,
    String? erro,
    bool? sucesso,
  }) =>
      NovaOcorrenciaState(
        carregando: carregando ?? this.carregando,
        erro: erro,
        sucesso: sucesso ?? this.sucesso,
      );
}

class NovaOcorrenciaNotifier extends Notifier<NovaOcorrenciaState> {
  @override
  NovaOcorrenciaState build() => const NovaOcorrenciaState();

  Future<void> enviar({
    required String titulo,
    required String descricao,
    required double latitude,
    required double longitude,
    required List<File> imagens,
    required String tipoProblema,
    required String urgencia,
  }) async {
    state = state.copyWith(carregando: true);

    final repositorio = ref.read(ocorrenciasRepositorioProvider);
    final fonteRemota = ref.read(ocorrenciasRemotaFonteProvider)
        as OcorrenciasRemotaFonteImpl;

    final ocorrencia = OcorrenciaEntidade(
      id: GeradorId.novo(),
      titulo: titulo,
      descricao: descricao,
      latitude: latitude,
      longitude: longitude,
      status: 'pendente',
      criadoEm: DateTime.now(),
    );

    final resultado = await repositorio.criar(ocorrencia);

    switch (resultado) {
      case Erro(:final falha):
        state = state.copyWith(carregando: false, erro: falha.mensagem);
        return;

      case Sucesso(:final dados):
        // Enviar imagens após criar a ocorrência
        for (final img in imagens) {
          try {
            await fonteRemota.enviarImagem(
              ocorrenciaId: dados.id,
              arquivo: img,
            );
          } catch (_) {
            // Falha no upload não cancela a ocorrência
          }
        }
        state = state.copyWith(carregando: false, sucesso: true);
        ref.invalidate(ocorrenciasListaProvider);
    }
  }

  void resetar() => state = const NovaOcorrenciaState();
}

final novaOcorrenciaProvider =
    NotifierProvider<NovaOcorrenciaNotifier, NovaOcorrenciaState>(
  NovaOcorrenciaNotifier.new,
);

// ---------------------------------------------------------------------------
// Notifier — atualização de status (admin/prefeitura)
// ---------------------------------------------------------------------------

class AtualizarStatusNotifier
    extends FamilyNotifier<AsyncValue<void>, String> {
  @override
  AsyncValue<void> build(String ocorrenciaId) =>
      const AsyncValue.data(null);

  Future<void> atualizar({
    required String novoStatus,
    String? observacao,
  }) async {
    state = const AsyncValue.loading();
    final repositorio = ref.read(ocorrenciasRepositorioProvider);

    final resultado = await repositorio.atualizar(
      OcorrenciaEntidade(
        id: arg,
        titulo: '',
        descricao: observacao ?? '',
        latitude: 0,
        longitude: 0,
        status: novoStatus,
        criadoEm: DateTime.now(),
      ),
    );

    state = switch (resultado) {
      Sucesso() => const AsyncValue.data(null),
      Erro(:final falha) => AsyncValue.error(falha.mensagem, StackTrace.empty),
    };

    if (state is AsyncData) {
      ref.invalidate(ocorrenciasListaProvider);
      ref.invalidate(ocorrenciaDetalheProvider(arg));
    }
  }
}

final atualizarStatusProvider = NotifierProvider.family<
    AtualizarStatusNotifier, AsyncValue<void>, String>(
  AtualizarStatusNotifier.new,
);