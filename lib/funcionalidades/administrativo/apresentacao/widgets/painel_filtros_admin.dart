import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../tema/cores.dart';
import '../providers/administrativo_provider.dart';
import '../../dados/fontes_dados/relatorios_remota_fonte.dart';

/// Painel lateral de filtros do painel administrativo.
class PainelFiltrosAdmin extends ConsumerWidget {
  const PainelFiltrosAdmin({
    super.key,
    this.largura = 260,
    this.mostrarResumo = true,
  });

  final double largura;
  final bool mostrarResumo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtros = ref.watch(filtrosAdminProvider);
    final notifier = ref.read(filtrosAdminProvider.notifier);
    final resumo = ref.watch(resumoRelatorioProvider);

    return SizedBox(
      width: largura,
      child: ListView(
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
              DropdownMenuItem(
                value: 'em_andamento',
                child: Text('Em andamento'),
              ),
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
              DropdownMenuItem(value: 'deslizamento', child: Text('Deslizamento')),
              DropdownMenuItem(value: 'outro', child: Text('Outro')),
            ],
            onChanged: notifier.definirTipo,
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Período'),
            subtitle: Text(_rotuloPeriodo(filtros)),
            trailing: filtros.dataInicio != null || filtros.dataFim != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: 'Limpar período',
                    onPressed: notifier.limparPeriodo,
                  )
                : null,
            onTap: () => _selecionarPeriodo(context, ref),
          ),
          if (mostrarResumo) ...[
            const Divider(height: 32),
            Text('Resumo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            resumo.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Erro ao carregar resumo'),
              data: (d) => _ResumoStatus(resumo: d),
            ),
            const SizedBox(height: 16),
            Text(
              'Classificação interna (categoria/prioridade/atribuído) requer '
              'campos adicionais no banco — não existem em banco.sql.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Cores.textoSecundario),
            ),
          ],
        ],
      ),
    );
  }

  String _rotuloPeriodo(FiltrosAdmin filtros) {
    if (filtros.dataInicio == null && filtros.dataFim == null) {
      return 'Qualquer data';
    }
    final inicio = filtros.dataInicio != null
        ? '${filtros.dataInicio!.day.toString().padLeft(2, '0')}/'
            '${filtros.dataInicio!.month.toString().padLeft(2, '0')}/'
            '${filtros.dataInicio!.year}'
        : '…';
    final fim = filtros.dataFim != null
        ? '${filtros.dataFim!.day.toString().padLeft(2, '0')}/'
            '${filtros.dataFim!.month.toString().padLeft(2, '0')}/'
            '${filtros.dataFim!.year}'
        : '…';
    return '$inicio — $fim';
  }

  Future<void> _selecionarPeriodo(BuildContext context, WidgetRef ref) async {
    final filtros = ref.read(filtrosAdminProvider);
    final intervalo = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange: filtros.dataInicio != null && filtros.dataFim != null
          ? DateTimeRange(start: filtros.dataInicio!, end: filtros.dataFim!)
          : null,
      locale: const Locale('pt', 'BR'),
    );
    if (intervalo != null) {
      ref.read(filtrosAdminProvider.notifier).definirPeriodo(
            inicio: intervalo.start,
            fim: DateTime(
              intervalo.end.year,
              intervalo.end.month,
              intervalo.end.day,
              23,
              59,
              59,
            ),
          );
    }
  }
}

class _ResumoStatus extends StatelessWidget {
  const _ResumoStatus({required this.resumo});

  final ResumoRelatorioModelo resumo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: resumo.porStatus.map((s) {
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
    );
  }
}

/// Aplica filtros administrativos a uma lista de ocorrências.
List<T> aplicarFiltrosAdmin<T>({
  required List<T> lista,
  required FiltrosAdmin filtros,
  required String Function(T) obterStatus,
  required String? Function(T) obterTipoProblema,
  required DateTime Function(T) obterData,
  String busca = '',
  String Function(T)? obterTextoBusca,
}) {
  return lista.where((item) {
    if (filtros.status != null && obterStatus(item) != filtros.status) {
      return false;
    }
    if (filtros.tipoProblema != null &&
        obterTipoProblema(item) != filtros.tipoProblema) {
      return false;
    }
    if (filtros.dataInicio != null &&
        obterData(item).isBefore(filtros.dataInicio!)) {
      return false;
    }
    if (filtros.dataFim != null && obterData(item).isAfter(filtros.dataFim!)) {
      return false;
    }
    if (busca.isNotEmpty && obterTextoBusca != null) {
      if (!obterTextoBusca(item).toLowerCase().contains(busca)) return false;
    }
    return true;
  }).toList();
}
