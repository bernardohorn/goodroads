import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../configuracao/ambiente/variaveis_ambiente.dart';
import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../../../../nucleo/injecao_dependencias/provedores_globais.dart';
import '../providers/mapas_provider.dart';
import '../../../ocorrencias/dominio/entidades/ocorrencia_entidade.dart';

/// Página de mapas com marcadores de ocorrências e roteamento.
class MapasPagina extends ConsumerStatefulWidget {
  const MapasPagina({super.key});

  @override
  ConsumerState<MapasPagina> createState() => _MapasPaginaState();
}

class _MapasPaginaState extends ConsumerState<MapasPagina> {
  GoogleMapController? _controller;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapasProvider.notifier).carregarInicial();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(mapasProvider);

    // Exibe SnackBar de erro de rota quando ocorre
    ref.listen<MapasState>(mapasProvider, (anterior, proximo) {
      if (proximo.erroRota != null &&
          proximo.erroRota != anterior?.erroRota &&
          mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(proximo.erroRota!),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (proximo.temRota &&
          proximo.rotaPolyline.isNotEmpty &&
          anterior?.rotaPolyline != proximo.rotaPolyline) {
        unawaited(_ajustarCameraParaRota(proximo));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          // Botão de limpar rota
          if (estado.temRota)
            IconButton(
              icon: const Icon(Icons.route_outlined),
              tooltip: 'Limpar rota',
              onPressed: () => ref.read(mapasProvider.notifier).limparRota(),
            ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (!VariaveisAmbiente.googleMapsConfigurado && kIsWeb)
            _buildErroMapsConfiguracao()
          else if (estado.posicaoAtual != null || estado.erro != null)
            _buildMap(estado),

          if (estado.carregando)
            const Center(child: CircularProgressIndicator()),

          if (estado.erro != null && !estado.carregando)
            _buildErroLocalizacao(estado),

          // Botão minha localização
          if (estado.posicaoAtual != null)
            _buildMyLocationButton(),

          // Banner de rota calculada
          if (estado.temRota && estado.rotaCalculada != null)
            _buildBannerRota(estado),

          // Loading de cálculo de rota
          if (estado.calculandoRota)
            _buildLoadingRota(),

          // Lista de ocorrências próximas
          if (estado.posicaoAtual != null && estado.ocorrencias.isNotEmpty)
            _buildDraggableSheet(estado),
        ],
      ),
    );
  }

  Widget _buildMap(MapasState estado) {
    final posicaoInicial = estado.posicaoAtual != null
        ? LatLng(estado.posicaoAtual!.latitude, estado.posicaoAtual!.longitude)
        : const LatLng(-23.5505, -46.6333); // São Paulo como fallback

    final polylines = <Polyline>{
      if (estado.temRota)
        Polyline(
          polylineId: const PolylineId('rota_principal'),
          points: estado.rotaPolyline,
          color: Colors.blue,
          width: 5,
          patterns: const [],
        ),
    };

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: posicaoInicial,
        zoom: 14,
      ),
      markers: _criarMarcadores(estado),
      polylines: polylines,
      onMapCreated: (controller) => _controller = controller,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
    );
  }

  Future<void> _ajustarCameraParaRota(MapasState estado) async {
    if (_controller == null || estado.rotaPolyline.isEmpty) return;

    double minLat = estado.rotaPolyline.first.latitude;
    double maxLat = minLat;
    double minLng = estado.rotaPolyline.first.longitude;
    double maxLng = minLng;

    for (final ponto in estado.rotaPolyline) {
      minLat = minLat < ponto.latitude ? minLat : ponto.latitude;
      maxLat = maxLat > ponto.latitude ? maxLat : ponto.latitude;
      minLng = minLng < ponto.longitude ? minLng : ponto.longitude;
      maxLng = maxLng > ponto.longitude ? maxLng : ponto.longitude;
    }

    if (estado.posicaoAtual != null) {
      minLat = minLat < estado.posicaoAtual!.latitude
          ? minLat
          : estado.posicaoAtual!.latitude;
      maxLat = maxLat > estado.posicaoAtual!.latitude
          ? maxLat
          : estado.posicaoAtual!.latitude;
      minLng = minLng < estado.posicaoAtual!.longitude
          ? minLng
          : estado.posicaoAtual!.longitude;
      maxLng = maxLng > estado.posicaoAtual!.longitude
          ? maxLng
          : estado.posicaoAtual!.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    await _controller!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 64),
    );
  }

  Widget _buildErroMapsConfiguracao() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Google Maps não configurado.\n'
              'Defina GOOGLE_MAPS_API_KEY no arquivo .env',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  ref.read(mapasProvider.notifier).carregarInicial(),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErroLocalizacao(MapasState estado) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              estado.erro!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  ref.read(mapasProvider.notifier).carregarInicial(),
              label: const Text('Tentar novamente'),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.settings),
              onPressed: () =>
                  ref.read(geolocalizacaoServicoProvider).abrirConfiguracoes(),
              label: const Text('Abrir configurações'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyLocationButton() {
    return Positioned(
      right: 16,
      bottom: 180,
      child: FloatingActionButton.small(
        heroTag: 'btn_my_location',
        onPressed: () async {
          await ref.read(mapasProvider.notifier).centralizarNaPosicaoAtual();
          final estado = ref.read(mapasProvider);
          if (estado.posicaoAtual != null && mounted) {
            unawaited(
              _controller?.animateCamera(
                CameraUpdate.newLatLng(
                  LatLng(
                    estado.posicaoAtual!.latitude,
                    estado.posicaoAtual!.longitude,
                  ),
                ),
              ),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildBannerRota(MapasState estado) {
    final rota = estado.rotaCalculada!;
    final destino = estado.ocorrenciaDestino;
    return Positioned(
      top: 8,
      left: 16,
      right: 16,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${rota.distanciaFormatada} · ${rota.duracaoFormatada}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (destino != null)
                      Text(
                        '${rota.resumo.isNotEmpty ? '${rota.resumo} · ' : ''}${destino.titulo}',
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                tooltip: 'Fechar rota',
                onPressed: () => ref.read(mapasProvider.notifier).limparRota(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingRota() {
    return const Positioned(
      top: 8,
      left: 16,
      right: 16,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Calculando rota...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableSheet(MapasState estado) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: 0.3,
        minChildSize: 0.15,
        maxChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Ocorrências próximas',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Text(
                        '${estado.ocorrencias.length}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 16),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: estado.ocorrencias.length,
                    itemBuilder: (context, index) {
                      return _buildOcorrenciaItem(estado.ocorrencias[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOcorrenciaItem(OcorrenciaEntidade ocorrencia) {
    return InkWell(
      onTap: () {
        unawaited(
          _controller?.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(ocorrencia.latitude, ocorrencia.longitude),
            ),
          ),
        );
        _sheetController.animateTo(
          0.15,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      onLongPress: () {
        context.push(
          RotasNomes.detalheOcorrencia.replaceFirst(':id', ocorrencia.id),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _corPorUrgencia(ocorrencia.urgencia),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _iconePorTipo(ocorrencia.tipoProblema),
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ocorrencia.titulo,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      BadgeStatus(status: ocorrencia.status),
                      const SizedBox(width: 8),
                      if (ocorrencia.urgencia != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _corPorUrgencia(ocorrencia.urgencia)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ocorrencia.urgencia!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _corPorUrgencia(ocorrencia.urgencia),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Set<Marker> _criarMarcadores(MapasState estado) {
    return estado.ocorrencias.map((o) {
      final ehDestino = estado.ocorrenciaDestino?.id == o.id;
      return Marker(
        markerId: MarkerId(o.id),
        position: LatLng(o.latitude, o.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          ehDestino
              ? BitmapDescriptor.hueBlue
              : _huePorStatus(o.status),
        ),
        onTap: () => _mostrarBottomSheetDetalhe(o),
      );
    }).toSet();
  }

  void _mostrarBottomSheetDetalhe(OcorrenciaEntidade ocorrencia) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ocorrencia.titulo,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                BadgeStatus(status: ocorrencia.status),
                const SizedBox(width: 12),
                if (ocorrencia.urgencia != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _corPorUrgencia(ocorrencia.urgencia)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ocorrencia.urgencia!.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _corPorUrgencia(ocorrencia.urgencia),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              ocorrencia.descricao,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (ocorrencia.municipio != null)
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    ocorrencia.municipio!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            const SizedBox(height: 24),
            // Botão de traçar rota
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.directions),
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(mapasProvider.notifier).calcularRota(ocorrencia);
                },
                label: const Text('Traçar rota até aqui'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(
                    RotasNomes.detalheOcorrencia.replaceFirst(
                      ':id',
                      ocorrencia.id,
                    ),
                  );
                },
                child: const Text('Ver detalhes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _huePorStatus(String status) {
    return switch (status) {
      'pendente' => BitmapDescriptor.hueOrange,
      'em_analise' => BitmapDescriptor.hueAzure,
      'em_andamento' => BitmapDescriptor.hueAzure,
      'resolvido' => BitmapDescriptor.hueGreen,
      'cancelado' => BitmapDescriptor.hueRed,
      _ => BitmapDescriptor.hueOrange,
    };
  }

  Color _corPorUrgencia(String? urgencia) {
    return switch (urgencia) {
      'baixa' => Colors.green,
      'media' => Colors.orange,
      'alta' => Colors.red,
      'critica' => Colors.purple,
      _ => Colors.grey,
    };
  }

  IconData _iconePorTipo(String? tipo) {
    return switch (tipo) {
      'buraco' => Icons.warning,
      'erosao' => Icons.terrain,
      'obstrucao' => Icons.block,
      'sinalizacao' => Icons.traffic,
      'iluminacao' => Icons.lightbulb,
      'ponte' => Icons.deck,
      'agua' => Icons.water_drop,
      'acessibilidade' => Icons.accessible,
      _ => Icons.report_problem,
    };
  }
}
