import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../compartilhado/modelos/resultado.dart';
import '../../../../nucleo/injecao_dependencias/provedores_globais.dart';
import '../../../../servicos/rota_servico.dart';
import '../../../ocorrencias/apresentacao/providers/ocorrencias_provider.dart';
import '../../../ocorrencias/dominio/entidades/ocorrencia_entidade.dart';

/// Estado do mapa.
class MapasState {
  const MapasState({
    this.posicaoAtual,
    this.ocorrencias = const [],
    this.carregando = false,
    this.erro,
    this.rotaPolyline = const [],
    this.ocorrenciaDestino,
    this.calculandoRota = false,
    this.erroRota,
    this.rotaCalculada,
  });

  final ({double latitude, double longitude})? posicaoAtual;
  final List<OcorrenciaEntidade> ocorrencias;
  final bool carregando;
  final String? erro;
  final List<LatLng> rotaPolyline;
  final OcorrenciaEntidade? ocorrenciaDestino;
  final bool calculandoRota;
  final String? erroRota;
  final RotaCalculada? rotaCalculada;

  bool get temRota => rotaPolyline.isNotEmpty;

  MapasState copyWith({
    ({double latitude, double longitude})? posicaoAtual,
    List<OcorrenciaEntidade>? ocorrencias,
    bool? carregando,
    String? erro,
    List<LatLng>? rotaPolyline,
    OcorrenciaEntidade? ocorrenciaDestino,
    bool? calculandoRota,
    String? erroRota,
    RotaCalculada? rotaCalculada,
    bool limparRota = false,
    bool limparErroRota = false,
  }) =>
      MapasState(
        posicaoAtual: posicaoAtual ?? this.posicaoAtual,
        ocorrencias: ocorrencias ?? this.ocorrencias,
        carregando: carregando ?? this.carregando,
        erro: erro,
        rotaPolyline: limparRota ? [] : (rotaPolyline ?? this.rotaPolyline),
        ocorrenciaDestino:
            limparRota ? null : (ocorrenciaDestino ?? this.ocorrenciaDestino),
        calculandoRota: calculandoRota ?? this.calculandoRota,
        erroRota:
            limparErroRota || limparRota ? null : (erroRota ?? this.erroRota),
        rotaCalculada:
            limparRota ? null : (rotaCalculada ?? this.rotaCalculada),
      );
}

/// Notifier do mapa.
class MapasNotifier extends Notifier<MapasState> {
  StreamSubscription<({double latitude, double longitude})>? _posicaoSub;

  @override
  MapasState build() {
    ref.onDispose(() => _posicaoSub?.cancel());
    return const MapasState();
  }

  /// Carrega a posição atual e as ocorrências próximas.
  Future<void> carregarInicial() async {
    state = state.copyWith(carregando: true, erro: null);

    final geo = ref.read(geolocalizacaoServicoProvider);
    final posicao = await geo.obterPosicaoAtual();

    if (posicao == null) {
      state = state.copyWith(
        carregando: false,
        erro:
            'Não foi possível obter sua localização.\n'
            'Verifique se o GPS está ativado e a permissão foi concedida.',
      );
      return;
    }

    await _carregarOcorrenciasProximas(posicao.latitude, posicao.longitude);
    _iniciarStreamPosicao();
  }

  void _iniciarStreamPosicao() {
    _posicaoSub?.cancel();
    final geo = ref.read(geolocalizacaoServicoProvider);
    _posicaoSub = geo.streamPosicao().listen(
      (posicao) {
        state = state.copyWith(posicaoAtual: posicao);
      },
      onError: (Object e) {
        debugPrint('[GoodRoads] Erro no stream de localização: $e');
      },
    );
  }

  /// Recarrega as ocorrências com base em uma posição específica.
  Future<void> recarregarPosicao(double latitude, double longitude) async {
    state = state.copyWith(carregando: true, erro: null);
    await _carregarOcorrenciasProximas(latitude, longitude);
  }

  Future<void> _carregarOcorrenciasProximas(
    double latitude,
    double longitude,
  ) async {
    final repositorio = ref.read(ocorrenciasRepositorioProvider);
    final resultado = await repositorio.listarProximas(
      latitude: latitude,
      longitude: longitude,
      raioKm: 5,
    );

    switch (resultado) {
      case Sucesso(:final dados):
        state = state.copyWith(
          posicaoAtual: (latitude: latitude, longitude: longitude),
          ocorrencias: dados,
          carregando: false,
        );
      case Erro(:final falha):
        state = state.copyWith(
          posicaoAtual: (latitude: latitude, longitude: longitude),
          carregando: false,
          erro: falha.mensagem,
        );
    }
  }

  /// Centraliza o mapa na posição atual do usuário.
  Future<void> centralizarNaPosicaoAtual() async {
    final geo = ref.read(geolocalizacaoServicoProvider);
    final posicao = await geo.obterPosicaoAtual();

    if (posicao != null) {
      state = state.copyWith(posicaoAtual: posicao);
    }
  }

  /// Calcula e exibe a rota da posição atual até a [ocorrencia].
  Future<void> calcularRota(OcorrenciaEntidade ocorrencia) async {
    final posicao = state.posicaoAtual;
    if (posicao == null) {
      state = state.copyWith(
        erroRota: 'Obtenha sua localização antes de traçar a rota.',
        limparErroRota: false,
      );
      return;
    }

    state = state.copyWith(
      calculandoRota: true,
      ocorrenciaDestino: ocorrencia,
      limparErroRota: true,
    );

    final rotaServico = ref.read(rotaServicoProvider);
    final resultado = await rotaServico.calcularRota(
      origem: LatLng(posicao.latitude, posicao.longitude),
      destino: LatLng(ocorrencia.latitude, ocorrencia.longitude),
    );

    if (resultado != null) {
      state = state.copyWith(
        calculandoRota: false,
        rotaPolyline: resultado.pontos,
        rotaCalculada: resultado,
      );
      debugPrint(
        '[GoodRoads] Rota calculada: ${resultado.distanciaFormatada}, '
        '${resultado.duracaoFormatada}.',
      );
    } else {
      state = state.copyWith(
        calculandoRota: false,
        erroRota:
            'Não foi possível calcular a rota.\n'
            'Verifique a conexão e se a chave da API está configurada.',
        limparRota: false,
        limparErroRota: false,
      );
    }
  }

  /// Remove a rota atual do mapa.
  void limparRota() {
    state = state.copyWith(limparRota: true);
  }
}

/// Provider do mapa.
final mapasProvider = NotifierProvider<MapasNotifier, MapasState>(
  MapasNotifier.new,
);
