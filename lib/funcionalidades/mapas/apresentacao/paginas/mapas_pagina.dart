import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../compartilhado/widgets/estado_erro_carregamento.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../../../ocorrencias/apresentacao/providers/ocorrencias_provider.dart';
import '../../../ocorrencias/dominio/entidades/ocorrencia_entidade.dart';

/// Página de mapas com marcadores de ocorrências.
class MapasPagina extends ConsumerStatefulWidget {
  const MapasPagina({super.key});

  @override
  ConsumerState<MapasPagina> createState() => _MapasPaginaState();
}

class _MapasPaginaState extends ConsumerState<MapasPagina> {
  GoogleMapController? _controller;
  String? _selecionadaId;

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(ocorrenciasMapaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: estado.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EstadoErroCarregamento(
          erro: e,
          titulo: 'Falha ao carregar mapa',
          aoTentarNovamente: () => ref.refresh(ocorrenciasMapaProvider),
        ),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text('Nenhuma ocorrência no mapa.'));
          }

          final marcadores = _criarMarcadores(lista);
          final centro = LatLng(lista.first.latitude, lista.first.longitude);

          return Column(
            children: [
              Expanded(
                flex: 3,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: centro,
                    zoom: 12,
                  ),
                  markers: marcadores,
                  onMapCreated: (c) => _controller = c,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
              Expanded(
                flex: 2,
                child: RefreshIndicator(
                  onRefresh: () async => ref.refresh(ocorrenciasMapaProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: lista.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final o = lista[i];
                      final selecionada = _selecionadaId == o.id;
                      return CartaoOcorrenciaResumo(
                        ocorrencia: o,
                        aoTocar: () {
                          setState(() => _selecionadaId = o.id);
                          _controller?.animateCamera(
                            CameraUpdate.newLatLng(
                              LatLng(o.latitude, o.longitude),
                            ),
                          );
                          context.push(
                            RotasNomes.detalheOcorrencia
                                .replaceFirst(':id', o.id),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
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
        infoWindow: InfoWindow(
          title: o.titulo,
          snippet: BadgeStatus.rotuloECores(o.status).$3,
          onTap: () => context.push(
            RotasNomes.detalheOcorrencia.replaceFirst(':id', o.id),
          ),
        ),
        onTap: () {
          setState(() => _selecionadaId = o.id);
          context.push(
            RotasNomes.detalheOcorrencia.replaceFirst(':id', o.id),
          );
        },
      );
    }).toSet();
  }

  double _huePorStatus(String status) {
    return switch (status) {
      'pendente' => BitmapDescriptor.hueOrange,
      'em_analise' => BitmapDescriptor.hueAzure,
      'em_andamento' => BitmapDescriptor.hueAzure,
      'resolvido' => BitmapDescriptor.hueGreen,
      _ => BitmapDescriptor.hueOrange,
    };
  }
}
