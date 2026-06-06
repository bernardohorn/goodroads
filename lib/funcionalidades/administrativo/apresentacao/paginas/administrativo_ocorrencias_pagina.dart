import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../rotas/rotas_nomes.dart';
import '../../../../tema/cores.dart';
import '../../../ocorrencias/apresentacao/providers/ocorrencias_provider.dart';
import '../../../ocorrencias/dominio/entidades/ocorrencia_entidade.dart';

/// Filtro de status exibido no painel.
const _filtros = [
  ('todos', 'Todos'),
  ('pendente', 'Pendentes'),
  ('em_analise', 'Em análise'),
  ('em_andamento', 'Em andamento'),
  ('resolvido', 'Resolvidos'),
];

class AdministrativoOcorrenciasPagina extends ConsumerStatefulWidget {
  const AdministrativoOcorrenciasPagina({super.key});

  @override
  ConsumerState<AdministrativoOcorrenciasPagina> createState() =>
      _AdministrativoOcorrenciasPaginaState();
}

class _AdministrativoOcorrenciasPaginaState
    extends ConsumerState<AdministrativoOcorrenciasPagina> {
  String _filtroAtivo = 'todos';

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(ocorrenciasListaProvider);

    return Scaffold(
      body: Column(
        children: [
          // ── Barra de filtros ───────────────────────────────────
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Gerenciar ocorrências',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 12,
                  ),
                  child: Row(
                    children: _filtros.map((f) {
                      final ativo = _filtroAtivo == f.$1;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(f.$2),
                          selected: ativo,
                          onSelected: (_) =>
                              setState(() => _filtroAtivo = f.$1),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Divider(height: 1),
              ],
            ),
          ),

          // ── Lista ──────────────────────────────────────────────
          Expanded(
            child: estado.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Cores.erro),
                    const SizedBox(height: 12),
                    Text('Erro ao carregar dados',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: () =>
                          ref.refresh(ocorrenciasListaProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Recarregar'),
                    ),
                  ],
                ),
              ),
              data: (lista) {
                final filtrada = _filtroAtivo == 'todos'
                    ? lista
                    : lista
                        .where((o) => o.status == _filtroAtivo)
                        .toList();

                if (filtrada.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma ocorrência ${_filtroAtivo == 'todos' ? '' : 'com status "${_filtroAtivo}"'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.refresh(ocorrenciasListaProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtrada.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                    itemBuilder: (_, i) =>
                        _LinhaOcorrenciaAdmin(filtrada[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LinhaOcorrenciaAdmin extends ConsumerWidget {
  const _LinhaOcorrenciaAdmin(this.ocorrencia);

  final OcorrenciaEntidade ocorrencia;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ocorrencia.titulo,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                _UrgenciaBadge(ocorrencia.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              ocorrencia.descricao,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SeletorStatus(ocorrencia),
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  tooltip: 'Ver detalhes',
                  icon: const Icon(Icons.open_in_new, size: 18),
                  onPressed: () => context.push(
                    RotasNomes.detalheOcorrencia
                        .replaceFirst(':id', ocorrencia.id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Dropdown de atualização de status com feedback visual.
class _SeletorStatus extends ConsumerWidget {
  const _SeletorStatus(this.ocorrencia);

  final OcorrenciaEntidade ocorrencia;

  static const _opcoes = [
    ('pendente', 'Pendente'),
    ('em_analise', 'Em análise'),
    ('em_andamento', 'Em andamento'),
    ('resolvido', 'Resolvido'),
    ('cancelado', 'Cancelado'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadoAtualizacao =
        ref.watch(atualizarStatusProvider(ocorrencia.id));

    return DropdownButtonFormField<String>(
      value: ocorrencia.status,
      isDense: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        suffix: estadoAtualizacao is AsyncLoading
            ? const SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : null,
      ),
      items: _opcoes
          .map((o) => DropdownMenuItem(
                value: o.$1,
                child: Text(o.$2),
              ))
          .toList(),
      onChanged: (novoStatus) {
        if (novoStatus != null && novoStatus != ocorrencia.status) {
          ref
              .read(atualizarStatusProvider(ocorrencia.id).notifier)
              .atualizar(novoStatus: novoStatus);
        }
      },
    );
  }
}

class _UrgenciaBadge extends StatelessWidget {
  const _UrgenciaBadge(this.status);

  final String status;

  @override
  Widget build(BuildContext context) {
    final (cor, texto) = switch (status) {
      'pendente' => (Colors.orange, 'Pendente'),
      'em_analise' => (Colors.blue, 'Análise'),
      'em_andamento' => (Colors.purple, 'Andamento'),
      'resolvido' => (Colors.green, 'Resolvido'),
      'cancelado' => (Colors.grey, 'Cancelado'),
      _ => (Colors.grey, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cor.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: cor.shade800,
        ),
      ),
    );
  }
}