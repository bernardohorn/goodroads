import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../compartilhado/modelos/resultado.dart';
import '../../../../nucleo/injecao_dependencias/provedores_globais.dart';
import '../../../../servicos/geolocalizacao_servico.dart';
import '../../../ocorrencias/apresentacao/providers/ocorrencias_provider.dart';
import '../../../ocorrencias/dominio/entidades/ocorrencia_entidade.dart';

/// Estado do mapa.
class MapasState {
  const MapasState({
    this.posicaoAtual,
    this.ocorrencias = const [],
    this.carregando = false,
    this.erro,
  });

  final ({double latitude, double longitude})? posicaoAtual;
  final List<OcorrenciaEntidade> ocorrencias;
  final bool carregando;
  final String? erro;

  MapasState copyWith({
    ({double latitude, double longitude})? posicaoAtual,
    List<OcorrenciaEntidade>? ocorrencias,
    bool? carregando,
    String? erro,
  }) =>
      MapasState(
        posicaoAtual: posicaoAtual ?? this.posicaoAtual,
        ocorrencias: ocorrencias ?? this.ocorrencias,
        carregando: carregando ?? this.carregando,
        erro: erro,
      );
}

/// Notifier do mapa.
class MapasNotifier extends Notifier<MapasState> {
  @override
  MapasState build() => const MapasState();

  /// Carrega a posição atual e as ocorrências próximas.
  Future<void> carregarInicial() async {
    state = state.copyWith(carregando: true, erro: null);
    
    final geo = ref.read(geolocalizacaoServicoProvider);
    final posicao = await geo.obterPosicaoAtual();
    
    if (posicao == null) {
      state = state.copyWith(
        carregando: false,
        erro: 'Não foi possível obter sua localização. Verifique as permissões.',
      );
      return;
    }

    await _carregarOcorrenciasProximas(posicao.latitude, posicao.longitude);
  }

  /// Recarrega as ocorrências com base em uma posição específica.
  Future<void> recarregarPosicao(double latitude, double longitude) async {
    state = state.copyWith(carregando: true, erro: null);
    await _carregarOcorrenciasProximas(latitude, longitude);
  }

  Future<void> _carregarOcorrenciasProximas(double latitude, double longitude) async {
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
}

/// Provider do mapa.
final mapasProvider = NotifierProvider<MapasNotifier, MapasState>(
  MapasNotifier.new,
);
