import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../nucleo/injecao_dependencias/provedores_globais.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../../../ocorrencias/dominio/entidades/ocorrencia_entidade.dart';
import '../providers/mapas_provider.dart';

/// Página de mapas com marcadores de ocorrências usando OpenStreetMap.
class MapasPagina extends ConsumerStatefulWidget {
  const MapasPagina({super.key});

  @override
  ConsumerState<MapasPagina> createState() => _MapasPaginaState();
}

class _MapasPaginaState extends ConsumerState<MapasPagina> {
  final MapController _mapController = MapController();
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
    _mapController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(mapasProvider);

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
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
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
          if (estado.posicaoAtual != null || estado.erro != null)
            _buildMap(estado),

          if (estado.carregando)
            const Center(child: CircularProgressIndicator()),

          if (estado.erro != null && !estado.carregando)
            _buildErroLocalizacao(estado),

          // Botão minha localização
          if (estado.posicaoAtual != null)
            _buildMyLocationButton(estado),

          // Lista de ocorrências próximas
          if (estado.posicaoAtual != null && estado.ocorrencias.isNotEmpty)
            _buildDraggableSheet(estado),
        ],
      ),
    );
  }

  Widget _buildMap(MapasState estado) {
    final center = estado.posicaoAtual != null
        ? LatLng(estado.posicaoAtual!.latitude, estado.posicaoAtual!.longitude)
        : const LatLng(-23.5505, -46.6333);

    final markers = <Marker>[];

    // Marcador da posição atual
    if (estado.posicaoAtual != null) {
      markers.add(
        Marker(
          point: center,
          width: 20,
          height: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      );
    }

    // Marcadores das ocorrências
    for (final o in estado.ocorrencias) {
      markers.add(
        Marker(
          point: LatLng(o.latitude, o.longitude),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _mostrarBottomSheetDetalhe(o),
            child: Container(
              decoration: BoxDecoration(
                color: _corPorStatus(o.status),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(51),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _iconePorTipo(o.tipoProblema),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 14,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.grb.goodroads',
        ),
        MarkerLayer(markers: markers),
      ],
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
              onPressed: () => ref
                  .read(geolocalizacaoServicoProvider)
                  .abrirConfiguracoes(),
              label: const Text('Abrir configurações'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyLocationButton(MapasState estado) {
    return Positioned(
      right: 16,
      bottom: 180,
      child: FloatingActionButton.small(
        heroTag: 'btn_my_location',
        onPressed: () async {
          await ref.read(mapasProvider.notifier).centralizarNaPosicaoAtual();
          if (estado.posicaoAtual != null && mounted) {
            _mapController.move(
              LatLng(
                estado.posicaoAtual!.latitude,
                estado.posicaoAtual!.longitude,
              ),
              14,
            );
          }
        },
        child: const Icon(Icons.my_location),
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
        _mapController.move(
          LatLng(ocorrencia.latitude, ocorrencia.longitude),
          16,
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
                color: _corPorStatus(ocorrencia.status),
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
                  BadgeStatus(status: ocorrencia.status),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Color _corPorStatus(String status) {
    return switch (status) {
      'pendente' => Colors.orange,
      'em_analise' => Colors.blue,
      'em_andamento' => Colors.blue,
      'resolvido' => Colors.green,
      'cancelado' => Colors.red,
      _ => Colors.grey,
    };
  }

  IconData _iconePorTipo(String? tipo) {
    return switch (tipo) {
      'buraco' => Icons.warning,
      'alagamento' => Icons.water,
      'deslizamento' => Icons.landslide,
      'queda_de_arvore' => Icons.park,
      'ponte_danificada' => Icons.dangerous,
      'erosao' => Icons.terrain,
      'lama_atoleiro' => Icons.water_drop,
      'sinalizacao_ausente' => Icons.traffic,
      'drenagem_obstruida' => Icons.water_damage,
      _ => Icons.report_problem,
    };
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
                BadgeStatus(status: ocorrencia.status),
              ],
            ),
            const SizedBox(height: 16),
            if (ocorrencia.descricao.isNotEmpty)
              Text(
                ocorrencia.descricao,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(
                    RotasNomes.detalheOcorrencia.replaceFirst(':id', ocorrencia.id),
                  );
                },
                child: const Text('Ver detalhes completos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
