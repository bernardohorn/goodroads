import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../compartilhado/widgets/cartao_ocorrencia_resumo.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../../../../tema/cores.dart';
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
                e.toString(),
                textAlign: TextAlign.center,
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
                  itemBuilder: (_, i) => CartaoOcorrenciaResumo(
                    ocorrencia: lista[i],
                    aoTocar: () => context.push(
                      RotasNomes.detalheOcorrencia
                          .replaceFirst(':id', lista[i].id),
                    ),
                  ),
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
