import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../compartilhado/widgets/estado_erro_carregamento.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../../../ocorrencias/apresentacao/providers/ocorrencias_provider.dart';
import '../../../ocorrencias/dominio/entidades/ocorrencia_entidade.dart';
import '../providers/administrativo_provider.dart';
import '../widgets/painel_filtros_admin.dart';

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
          const PainelFiltrosAdmin(mostrarResumo: false),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Ocorrências',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(width: 24),
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
                    error: (e, _) => EstadoErroCarregamento(
                      erro: e,
                      aoTentarNovamente: () =>
                          ref.refresh(ocorrenciasListaProvider),
                    ),
                    data: (lista) {
                      final filtrada = aplicarFiltrosAdmin<OcorrenciaEntidade>(
                        lista: lista,
                        filtros: filtros,
                        busca: _busca,
                        obterStatus: (o) => o.status,
                        obterTipoProblema: (o) => o.tipoProblema,
                        obterData: (o) => o.criadoEm,
                        obterTextoBusca: (o) =>
                            '${o.descricao} ${o.protocolo ?? ''} ${o.titulo}',
                      );
                      final totalPaginas =
                          (filtrada.length / _itensPorPagina).ceil();
                      final inicio = _pagina * _itensPorPagina;
                      final pagina =
                          filtrada.skip(inicio).take(_itensPorPagina);

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
                                    DataCell(Text(
                                        o.protocolo ?? o.id.substring(0, 8))),
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
                                          icon: const Icon(
                                              Icons.visibility_outlined),
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
}
