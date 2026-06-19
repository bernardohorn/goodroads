import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../../../../compartilhado/modelos/resultado.dart';
import '../../../../nucleo/injecao_dependencias/provedores_globais.dart';
import '../../../autenticacao/apresentacao/providers/autenticacao_provider.dart';
import '../../dados/fontes_dados/ocorrencias_remota_fonte_impl.dart';
import '../../dados/repositorios/ocorrencias_repositorio_impl.dart';
import '../../dominio/casos_uso/listar_ocorrencias_caso_uso.dart';
import '../../dominio/entidades/ocorrencia_entidade.dart';

// ---------------------------------------------------------------------------
// Fonte + Repositório
// ---------------------------------------------------------------------------

final ocorrenciasRemotaFonteProvider =
    Provider<OcorrenciasRemotaFonteImpl>((ref) {
  return OcorrenciasRemotaFonteImpl(ref.watch(dioProvider));
});

final ocorrenciasRepositorioProvider = Provider<OcorrenciasRepositorioImpl>(
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
// FutureProvider — lista completa
// ---------------------------------------------------------------------------

final ocorrenciasListaProvider =
    FutureProvider<List<OcorrenciaEntidade>>((ref) async {
  final casoUso = ref.watch(listarOcorrenciasCasoUsoProvider);
  final resultado = await casoUso.executar();
  return switch (resultado) {
    Sucesso(:final dados) => dados,
    Erro(:final falha) => throw Exception(falha.mensagem),
  };
});

/// Ocorrências próximas à localização atual (mapa).
final ocorrenciasMapaProvider =
    FutureProvider<List<OcorrenciaEntidade>>((ref) async {
  final geo = ref.watch(geolocalizacaoServicoProvider);
  final posicao = await geo.obterPosicaoAtual();
  if (posicao == null) {
    final resultado = await ref.watch(ocorrenciasRepositorioProvider).listar();
    return switch (resultado) {
      Sucesso(:final dados) => dados,
      Erro(:final falha) => throw Exception(falha.mensagem),
    };
  }

  final resultado =
      await ref.watch(ocorrenciasRepositorioProvider).listarProximas(
            latitude: posicao.latitude,
            longitude: posicao.longitude,
          );
  return switch (resultado) {
    Sucesso(:final dados) => dados,
    Erro(:final falha) => throw Exception(falha.mensagem),
  };
});

// ---------------------------------------------------------------------------
// FutureProvider — detalhe
// ---------------------------------------------------------------------------

final ocorrenciaDetalheProvider =
    FutureProvider.family<OcorrenciaEntidade, String>((ref, id) async {
  final repositorio = ref.watch(ocorrenciasRepositorioProvider);
  final resultado = await repositorio.obterPorId(id);
  return switch (resultado) {
    Sucesso(:final dados) => dados,
    Erro(:final falha) => throw Exception(falha.mensagem),
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
    required String descricao,
    required double latitude,
    required double longitude,
    required List<File> imagens,
    required String tipoProblema,
    required String urgencia,
    String? municipio,
  }) async {
    state = state.copyWith(carregando: true, erro: null);

    final repositorio = ref.read(ocorrenciasRepositorioProvider);
    final fonteRemota = ref.read(ocorrenciasRemotaFonteProvider);

    final ocorrencia = OcorrenciaEntidade(
      id: '',
      titulo: tipoProblema.replaceAll('_', ' '),
      descricao: descricao,
      latitude: latitude,
      longitude: longitude,
      status: 'pendente',
      criadoEm: DateTime.now(),
      tipoProblema: tipoProblema,
      urgencia: urgencia,
      municipio: municipio,
    );

    final resultado = await repositorio.criar(ocorrencia);

    switch (resultado) {
      case Erro(:final falha):
        state = state.copyWith(carregando: false, erro: falha.mensagem);
        return;

      case Sucesso(:final dados):
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
        ref.invalidate(ocorrenciasMapaProvider);
        ref.invalidate(historicoListaProvider);
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
        descricao: '',
        latitude: 0,
        longitude: 0,
        status: novoStatus,
        criadoEm: DateTime.now(),
      ),
      observacao: observacao,
    );

    state = switch (resultado) {
      Sucesso() => const AsyncValue.data(null),
      Erro(:final falha) => AsyncValue.error(falha.mensagem, StackTrace.empty),
    };

    if (state is AsyncData) {
      ref.invalidate(ocorrenciasListaProvider);
      ref.invalidate(ocorrenciasMapaProvider);
      ref.invalidate(ocorrenciaDetalheProvider(arg));
    }
  }
}

final atualizarStatusProvider = NotifierProvider.family<
    AtualizarStatusNotifier, AsyncValue<void>, String>(
  AtualizarStatusNotifier.new,
);

// ---------------------------------------------------------------------------
// Histórico paginado (client-side)
// ---------------------------------------------------------------------------

class HistoricoListaNotifier extends Notifier<AsyncValue<List<OcorrenciaEntidade>>> {
  static const _tamanhoPagina = 15;

  String _filtro = 'minhas';
  int _pagina = 1;
  List<OcorrenciaEntidade> _todas = [];

  @override
  AsyncValue<List<OcorrenciaEntidade>> build() {
    _carregar();
    return const AsyncValue.loading();
  }

  List<OcorrenciaEntidade> get _filtradas {
    if (_filtro == 'todas') return _todas;
    final usuario = ref.read(autenticacaoControladorProvider).valueOrNull;
    if (usuario == null) return [];
    return _todas.where((o) => o.usuarioId == usuario.id).toList();
  }

  Future<void> _carregar() async {
    state = const AsyncValue.loading();
    final resultado = await ref.read(ocorrenciasRepositorioProvider).listar();
    switch (resultado) {
      case Sucesso(:final dados):
        _todas = dados;
        _pagina = 1;
        state = AsyncValue.data(_paginaAtual);
      case Erro(:final falha):
        state = AsyncValue.error(falha.mensagem, StackTrace.empty);
    }
  }

  List<OcorrenciaEntidade> get _paginaAtual {
    final fim = (_pagina * _tamanhoPagina).clamp(0, _filtradas.length);
    return _filtradas.sublist(0, fim);
  }

  bool get temMais => _paginaAtual.length < _filtradas.length;

  Future<void> recarregar() => _carregar();

  void alterarFiltro(String filtro) {
    _filtro = filtro;
    _pagina = 1;
    state = AsyncValue.data(_paginaAtual);
  }

  void carregarMais() {
    if (!temMais) return;
    _pagina++;
    state = AsyncValue.data(_paginaAtual);
  }
}

final historicoListaProvider = NotifierProvider<
    HistoricoListaNotifier, AsyncValue<List<OcorrenciaEntidade>>>(
  HistoricoListaNotifier.new,
);
