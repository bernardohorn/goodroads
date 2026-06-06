import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../rotas/rotas_nomes.dart';
import '../../../../tema/cores.dart';
import '../../dominio/entidades/ocorrencia_entidade.dart';
import '../providers/ocorrencias_provider.dart';

class OcorrenciasPagina extends ConsumerWidget {
  const OcorrenciasPagina({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(ocorrenciasListaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ocorrências')),
      body: estado.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 48, color: Cores.textoSecundario),
              const SizedBox(height: 12),
              Text(
                'Falha ao carregar ocorrências',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () => ref.refresh(ocorrenciasListaProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
        data: (lista) => lista.isEmpty
            ? _EstadoVazio(context)
            : RefreshIndicator(
                onRefresh: () async => ref.refresh(ocorrenciasListaProvider),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: lista.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _CartaoOcorrencia(lista[i]),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RotasNomes.novaOcorrencia),
        icon: const Icon(Icons.add),
        label: const Text('Nova ocorrência'),
      ),
    );
  }

  Widget _EstadoVazio(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline,
                size: 72, color: Cores.primariaClara),
            const SizedBox(height: 16),
            Text(
              'Nenhuma ocorrência registrada',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Registre problemas nas estradas rurais',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
}

class _CartaoOcorrencia extends StatelessWidget {
  const _CartaoOcorrencia(this.ocorrencia);

  final OcorrenciaEntidade ocorrencia;

  @override
  Widget build(BuildContext context) {
    final badge = _StatusBadge(ocorrencia.status);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(
          RotasNomes.detalheOcorrencia.replaceFirst(':id', ocorrencia.id),
        ),
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
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  badge,
                ],
              ),
              const SizedBox(height: 6),
              Text(
                ocorrencia.descricao,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14,
                      color: Cores.textoSecundario),
                  const SizedBox(width: 4),
                  Text(
                    '${ocorrencia.latitude.toStringAsFixed(4)}, '
                    '${ocorrencia.longitude.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  if (ocorrencia.imagensUrls.isNotEmpty) ...[
                    const Icon(Icons.photo_outlined, size: 14,
                        color: Cores.textoSecundario),
                    const SizedBox(width: 4),
                    Text(
                      '${ocorrencia.imagensUrls.length} foto(s)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.status);

  final String status;

  @override
  Widget build(BuildContext context) {
    final (cor, texto) = switch (status) {
      'pendente' => (Colors.orange.shade100, 'Pendente'),
      'em_analise' => (Colors.blue.shade100, 'Em análise'),
      'em_andamento' => (Colors.purple.shade100, 'Em andamento'),
      'resolvido' => (Colors.green.shade100, 'Resolvido'),
      'cancelado' => (Colors.grey.shade200, 'Cancelado'),
      _ => (Colors.grey.shade200, status),
    };
    final corTexto = switch (status) {
      'pendente' => Colors.orange.shade800,
      'em_analise' => Colors.blue.shade800,
      'em_andamento' => Colors.purple.shade800,
      'resolvido' => Colors.green.shade800,
      _ => Colors.grey.shade700,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: corTexto,
        ),
      ),
    );
  }
}