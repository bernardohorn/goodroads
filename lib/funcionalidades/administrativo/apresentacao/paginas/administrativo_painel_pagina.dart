import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../compartilhado/widgets/estado_erro_carregamento.dart';
import '../../../../compartilhado/widgets/layout_responsivo.dart';
import '../../../../tema/cores.dart';
import '../providers/administrativo_provider.dart';

/// Dashboard administrativo com cards e gráficos.
class AdministrativoPainelPagina extends ConsumerWidget {
  const AdministrativoPainelPagina({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumo = ref.watch(resumoRelatorioProvider);
    final porMes = ref.watch(ocorrenciasPorMesProvider);

    return Scaffold(
      body: resumo.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EstadoErroCarregamento(
          erro: e,
          aoTentarNovamente: () => ref.refresh(resumoRelatorioProvider),
        ),
        data: (dados) {
          final total = dados.totalGeral();
          final pendentes = dados.contagemStatus('pendente');
          final andamento = dados.contagemStatus('em_andamento') +
              dados.contagemStatus('em_analise');
          final resolvidas = dados.contagemStatus('resolvido');

          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(resumoRelatorioProvider);
              ref.refresh(ocorrenciasPorMesProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  LayoutResponsivo(
                    mobile: Column(
                      children: [
                        _CardTotal(
                          titulo: 'Total',
                          valor: total,
                          cor: Cores.primaria,
                        ),
                        const SizedBox(height: 12),
                        _CardTotal(
                          titulo: 'Pendentes',
                          valor: pendentes,
                          cor: Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        _CardTotal(
                          titulo: 'Em andamento',
                          valor: andamento,
                          cor: Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        _CardTotal(
                          titulo: 'Resolvidas',
                          valor: resolvidas,
                          cor: Colors.green,
                        ),
                      ],
                    ),
                    desktop: Row(
                      children: [
                        Expanded(
                          child: _CardTotal(
                            titulo: 'Total',
                            valor: total,
                            cor: Cores.primaria,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _CardTotal(
                            titulo: 'Pendentes',
                            valor: pendentes,
                            cor: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _CardTotal(
                            titulo: 'Em andamento',
                            valor: andamento,
                            cor: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _CardTotal(
                            titulo: 'Resolvidas',
                            valor: resolvidas,
                            cor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Ocorrências por mês',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Calculado a partir da listagem (backend não expõe por_mes).',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Cores.textoSecundario,
                        ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 240,
                    child: porMes.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => EstadoErroCarregamento(
                        erro: e,
                        aoTentarNovamente: () =>
                            ref.refresh(ocorrenciasPorMesProvider),
                      ),
                      data: (meses) => BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: meses
                                  .map((m) => m.quantidade)
                                  .fold(0, (a, b) => a > b ? a : b)
                                  .toDouble() +
                              1,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, _) {
                                  if (v.toInt() >= meses.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      meses[v.toInt()].rotulo,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            topTitles: const AxisTitles(),
                            rightTitles: const AxisTitles(),
                          ),
                          barGroups: meses
                              .asMap()
                              .entries
                              .map(
                                (e) => BarChartGroupData(
                                  x: e.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: e.value.quantidade.toDouble(),
                                      color: Cores.primaria,
                                      width: 20,
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Ocorrências por status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: dados.porStatus.map((s) {
                          final cor = switch (s.status) {
                            'pendente' => Colors.orange,
                            'em_analise' => Colors.lightBlue,
                            'em_andamento' => Colors.blue,
                            'resolvido' => Colors.green,
                            _ => Colors.grey,
                          };
                          return PieChartSectionData(
                            value: s.quantidade.toDouble(),
                            title: '${s.quantidade}',
                            color: cor,
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Ocorrências por tipo de problema',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 240,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, _) {
                                if (v.toInt() >= dados.porTipoProblema.length) {
                                  return const SizedBox.shrink();
                                }
                                final tipo =
                                    dados.porTipoProblema[v.toInt()].tipoProblema;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    tipo.replaceAll('_', '\n'),
                                    style: const TextStyle(fontSize: 9),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          topTitles: const AxisTitles(),
                          rightTitles: const AxisTitles(),
                        ),
                        barGroups: dados.porTipoProblema
                            .asMap()
                            .entries
                            .map(
                              (e) => BarChartGroupData(
                                x: e.key,
                                barRods: [
                                  BarChartRodData(
                                    toY: e.value.quantidade.toDouble(),
                                    color: Cores.primaria,
                                    width: 16,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CardTotal extends StatelessWidget {
  const _CardTotal({
    required this.titulo,
    required this.valor,
    required this.cor,
  });

  final String titulo;
  final int valor;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              '$valor',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: cor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
