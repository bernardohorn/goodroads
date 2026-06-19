import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../compartilhado/widgets/estado_erro_carregamento.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../../../ocorrencias/apresentacao/providers/ocorrencias_provider.dart';
import '../../../ocorrencias/dominio/entidades/ocorrencia_entidade.dart';
import '../providers/administrativo_provider.dart';
import '../widgets/painel_filtros_admin.dart';

/// Mapa administrativo com marcadores de todas as ocorrências e filtros laterais.
class AdministrativoMapaPagina extends ConsumerStatefulWidget {
  const AdministrativoMapaPagina({super.key});

  @override
  ConsumerState<AdministrativoMapaPagina> createState() =>
      _AdministrativoMapaPaginaState();
}

class _AdministrativoMapaPaginaState
    extends ConsumerState<AdministrativoMapaPagina> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    final mapa = ref.watch(ocorrenciasAdminMapaProvider);

    return Scaffold(
      body: Row(
        children: [
          const PainelFiltrosAdmin(),
          const VerticalDivider(width: 1),
          Expanded(
            child: mapa.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => EstadoErroCarregamento(
                erro: e,
                titulo: 'Falha ao carregar mapa',
                aoTentarNovamente: () =>
                    ref.refresh(ocorrenciasAdminMapaProvider),
              ),
              data: (lista) {
                if (lista.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma ocorrência corresponde aos filtros.'),
                  );
                }

                final centro = LatLng(lista.first.latitude, lista.first.longitude);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            'Mapa administrativo',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          Text('${lista.length} ocorrência(s)'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: centro,
                          zoom: 10,
                        ),
                        markers: _criarMarcadores(lista),
                        onMapCreated: (c) => _controller = c,
                        myLocationButtonEnabled: false,
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(12),
                        itemCount: lista.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final o = lista[i];
                          return SizedBox(
                            width: 220,
                            child: Card(
                              child: InkWell(
                                onTap: () {
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
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              o.titulo,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                          ),
                                          BadgeStatus(status: o.status),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        o.municipio ?? o.descricao,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _criarMarcadores(List<OcorrenciaEntidade> lista) {
    return lista.map((o) {
      return Marker(
        markerId: MarkerId(o.id),
        position: LatLng(o.latitude, o.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(_huePorStatus(o.status)),
        infoWindow: InfoWindow(
          title: o.titulo,
          snippet: BadgeStatus.rotuloECores(o.status).$3,
          onTap: () => context.push(
            RotasNomes.detalheOcorrencia.replaceFirst(':id', o.id),
          ),
        ),
        onTap: () => context.push(
          RotasNomes.detalheOcorrencia.replaceFirst(':id', o.id),
        ),
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
