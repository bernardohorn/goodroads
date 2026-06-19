import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../compartilhado/widgets/estado_erro_carregamento.dart';
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
        error: (e, _) => EstadoErroCarregamento(
          erro: e,
          aoTentarNovamente: () => ref.refresh(ocorrenciasListaProvider),
        ),
        data: (lista) => lista.isEmpty
            ? _estadoVazio(context)
            : RefreshIndicator(
                onRefresh: () async => ref.refresh(ocorrenciasListaProvider),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: lista.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
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

  Widget _estadoVazio(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
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
