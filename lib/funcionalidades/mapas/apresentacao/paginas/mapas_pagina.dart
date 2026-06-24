import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../compartilhado/widgets/estado_erro_carregamento.dart';
import '../../../../configuracao/ambiente/variaveis_ambiente.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../providers/mapas_provider.dart';
import '../../../ocorrencias/dominio/entidades/ocorrencia_entidade.dart';

/// Página de mapas com marcadores de ocorrências.
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
  Widget build(BuildContext context) {
    if (!VariaveisAmbiente.googleMapsConfigurado) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mapa')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Google Maps não configurado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Configure a chave da API do Google Maps no arquivo .env',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final estado = ref.watch(mapasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: Stack(
        children: [
          if (estado.posicaoAtual != null || estado.erro != null)
            _buildMap(estado),
          if (estado.carregando)
            const Center(child: CircularProgressIndicator()),
          if (estado.erro != null)
            Center(
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
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(mapasProvider.notifier).carregarInicial(),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          if (estado.posicaoAtual != null)
            _buildMyLocationButton(),
          if (estado.posicaoAtual != null && estado.ocorrencias.isNotEmpty)
            _buildDraggableSheet(estado),
        ],
      ),
    );
  }

  Widget _buildMap(MapasState estado) {
    final initialPosition = estado.posicaoAtual != null
        ? LatLng(estado.posicaoAtual!.latitude, estado.posicaoAtual!.longitude)
        : const LatLng(-23.5505, -46.6333); // São Paulo como fallback

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 14,
      ),
      markers: _criarMarcadores(estado.ocorrencias),
      onMapCreated: (controller) => _controller = controller,
      myLocationEnabled: true,
      myLocationButtonEnabled: false, // Usamos nosso próprio botão
      onCameraMove: (position) {
        // Debounce para recarregar ao mover o mapa
        // Implementação simplificada - pode ser melhorada com debounce
      },
      onCameraIdle: () async {
        // Camera position tracking removed - getCameraPosition not available
      },
    );
  }

  Widget _buildMyLocationButton() {
    return Positioned(
      right: 16,
      bottom: 180,
      child: FloatingActionButton.small(
        heroTag: 'my_location',
        onPressed: () async {
          await ref.read(mapasProvider.notifier).centralizarNaPosicaoAtual();
          final estado = ref.read(mapasProvider);
          if (estado.posicaoAtual != null) {
            _controller?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(
                  estado.posicaoAtual!.latitude,
                  estado.posicaoAtual!.longitude,
                ),
              ),
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
                      final ocorrencia = estado.ocorrencias[index];
                      return _buildOcorrenciaItem(ocorrencia);
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
        _controller?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(ocorrencia.latitude, ocorrencia.longitude),
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
                                .withOpacity(0.1),
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

  Set<Marker> _criarMarcadores(List<OcorrenciaEntidade> lista) {
    return lista.map((o) {
      return Marker(
        markerId: MarkerId(o.id),
        position: LatLng(o.latitude, o.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _huePorStatus(o.status),
        ),
        onTap: () {
          _mostrarBottomSheetDetalhe(o);
        },
      );
    }).toSet();
  }

  void _mostrarBottomSheetDetalhe(OcorrenciaEntidade ocorrencia) {
    showModalBottomSheet(
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
                          .withOpacity(0.1),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(
                    RotasNomes.detalheOcorrencia.replaceFirst(':id', ocorrencia.id),
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
