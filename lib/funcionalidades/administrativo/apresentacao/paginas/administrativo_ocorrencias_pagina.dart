import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../../../../tema/cores.dart';
import '../../../ocorrencias/apresentacao/providers/ocorrencias_provider.dart';
import '../../../ocorrencias/dominio/entidades/ocorrencia_entidade.dart';
import '../providers/administrativo_provider.dart';

/// Listagem administrativa de ocorrências com tabela e filtros.
class AdministrativoOcorrenciasPagina extends ConsumerStatefulWidget {
  const AdministrativoOcorrenciasPagina({super.key});

  @override
  ConsumerState<AdministrativoOcorrenciasPagina> createState() =>
      _AdministrativoOcorrenciasPaginaState();
}

class _AdministrativoOcorrenciasPaginaState
    extends ConsumerState<AdministrativoOcorrenciasPagina> {
  String _busca = '';
  int _pagina = 0;
  static const _itensPorPagina = 10;

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(ocorrenciasListaProvider);
    final filtros = ref.watch(filtrosAdminProvider);

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 260,
            child: _PainelFiltros(
              filtros: filtros,
              resumo: ref.watch(resumoRelatorioProvider),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Buscar por descrição ou protocolo...',
                            isDense: true,
                          ),
                          onChanged: (v) => setState(() {
                            _busca = v.toLowerCase();
                            _pagina = 0;
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: estado.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(e.toString()),
                          FilledButton.icon(
                            onPressed: () =>
                                ref.refresh(ocorrenciasListaProvider),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    ),
                    data: (lista) {
                      final filtrada = _aplicarFiltros(lista, filtros);
                      final totalPaginas =
                          (filtrada.length / _itensPorPagina).ceil();
                      final inicio = _pagina * _itensPorPagina;
                      final pagina = filtrada.skip(inicio).take(_itensPorPagina);

                      if (filtrada.isEmpty) {
                        return const Center(
                          child: Text('Nenhuma ocorrência encontrada.'),
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('Protocolo')),
                                  DataColumn(label: Text('Tipo')),
                                  DataColumn(label: Text('Status')),
                                  DataColumn(label: Text('Município')),
                                  DataColumn(label: Text('Data')),
                                  DataColumn(label: Text('Ações')),
                                ],
                                rows: pagina.map((o) {
                                  return DataRow(cells: [
                                    DataCell(Text(o.protocolo ?? o.id.substring(0, 8))),
                                    DataCell(Text(o.titulo)),
                                    DataCell(BadgeStatus(status: o.status)),
                                    DataCell(Text(o.municipio ?? '—')),
                                    DataCell(Text(
                                      '${o.criadoEm.day.toString().padLeft(2, '0')}/'
                                      '${o.criadoEm.month.toString().padLeft(2, '0')}/'
                                      '${o.criadoEm.year}',
                                    )),
                                    DataCell(Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.visibility_outlined),
                                          tooltip: 'Ver',
                                          onPressed: () => context.push(
                                            RotasNomes.detalheOcorrencia
                                                .replaceFirst(':id', o.id),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined),
                                          tooltip: 'Editar status',
                                          onPressed: () => context.push(
                                            RotasNomes.detalheOcorrencia
                                                .replaceFirst(':id', o.id),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline),
                                          tooltip: 'Excluir',
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Exclusão requer DELETE /api/ocorrencias/:id '
                                                  '(não implementado no backend).',
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    )),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: _pagina > 0
                                      ? () => setState(() => _pagina--)
                                      : null,
                                  icon: const Icon(Icons.chevron_left),
                                ),
                                Text(
                                  'Página ${_pagina + 1} de ${totalPaginas == 0 ? 1 : totalPaginas}',
                                ),
                                IconButton(
                                  onPressed: _pagina < totalPaginas - 1
                                      ? () => setState(() => _pagina++)
                                      : null,
                                  icon: const Icon(Icons.chevron_right),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<OcorrenciaEntidade> _aplicarFiltros(
    List<OcorrenciaEntidade> lista,
    FiltrosAdmin filtros,
  ) {
    return lista.where((o) {
      if (filtros.status != null && o.status != filtros.status) return false;
      if (filtros.tipoProblema != null &&
          o.tipoProblema != filtros.tipoProblema) {
        return false;
      }
      if (_busca.isNotEmpty) {
        final texto =
            '${o.descricao} ${o.protocolo ?? ''} ${o.titulo}'.toLowerCase();
        if (!texto.contains(_busca)) return false;
      }
      return true;
    }).toList();
  }
}

class _PainelFiltros extends ConsumerWidget {
  const _PainelFiltros({required this.filtros, required this.resumo});

  final FiltrosAdmin filtros;
  final AsyncValue<ResumoRelatorioModelo> resumo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(filtrosAdminProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Filtros', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        DropdownButtonFormField<String?>(
          value: filtros.status,
          decoration: const InputDecoration(labelText: 'Status'),
          items: const [
            DropdownMenuItem(value: null, child: Text('Todos')),
            DropdownMenuItem(value: 'pendente', child: Text('Pendente')),
            DropdownMenuItem(value: 'em_analise', child: Text('Em análise')),
            DropdownMenuItem(value: 'em_andamento', child: Text('Em andamento')),
            DropdownMenuItem(value: 'resolvido', child: Text('Resolvido')),
          ],
          onChanged: notifier.definirStatus,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          value: filtros.tipoProblema,
          decoration: const InputDecoration(labelText: 'Categoria'),
          items: const [
            DropdownMenuItem(value: null, child: Text('Todas')),
            DropdownMenuItem(value: 'buraco', child: Text('Buraco')),
            DropdownMenuItem(value: 'alagamento', child: Text('Alagamento')),
            DropdownMenuItem(value: 'outro', child: Text('Outro')),
          ],
          onChanged: notifier.definirTipo,
        ),
        const Divider(height: 32),
        Text('Resumo', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        resumo.when(
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const Text('Erro ao carregar resumo'),
          data: (d) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: d.porStatus.map((s) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    BadgeStatus(status: s.status),
                    const Spacer(),
                    Text('${s.quantidade}'),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 32),
        Text('Mapa', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: Consumer(
            builder: (context, ref, _) {
              final mapa = ref.watch(ocorrenciasAdminMapaProvider);
              return mapa.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(e.toString())),
                data: (lista) {
                  if (lista.isEmpty) {
                    return const Center(child: Text('Sem dados'));
                  }
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(lista.first.latitude, lista.first.longitude),
                      zoom: 10,
                    ),
                    markers: lista
                        .map(
                          (o) => Marker(
                            markerId: MarkerId(o.id),
                            position: LatLng(o.latitude, o.longitude),
                          ),
                        )
                        .toSet(),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Classificação interna (categoria/prioridade/atribuído) requer '
          'campos adicionais no banco — não existem em banco.sql.',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Cores.textoSecundario),
        ),
      ],
    );
  }
}
