import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/badge_status.dart';
import '../../../../compartilhado/widgets/estado_erro_carregamento.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../../../../tema/cores.dart';
import '../../../autenticacao/apresentacao/providers/autenticacao_provider.dart';
import '../../../ocorrencias/apresentacao/providers/ocorrencias_provider.dart';

/// Página inicial do aplicativo mobile.
class InicioPagina extends ConsumerWidget {
  const InicioPagina({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(autenticacaoControladorProvider).valueOrNull;
    final ocorrencias = ref.watch(ocorrenciasListaProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${usuario?.nome ?? 'visitante'}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push(RotasNomes.notificacoes),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(ocorrenciasListaProvider),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Cores.primariaClara,
                    child: Icon(Icons.add_road, color: Cores.primaria),
                  ),
                  title: const Text('Registrar ocorrência'),
                  subtitle:
                      const Text('Informe problemas em estradas rurais'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(RotasNomes.novaOcorrencia),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child:
                        Icon(Icons.map_outlined, color: Colors.blue.shade700),
                  ),
                  title: const Text('Ver mapa'),
                  subtitle: const Text('Ocorrências próximas a você'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(RotasNomes.mapas),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Ocorrências recentes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ocorrencias.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => EstadoErroCarregamento(
                  erro: e,
                  aoTentarNovamente: () =>
                      ref.refresh(ocorrenciasListaProvider),
                ),
                data: (lista) {
                  final recentes = [...lista]
                    ..sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
                  final top3 = recentes.take(3).toList();

                  if (top3.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child:
                            Text('Nenhuma ocorrência registrada ainda.'),
                      ),
                    );
                  }

                  return Column(
                    children: top3
                        .map(
                          (o) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CartaoOcorrenciaResumo(
                              ocorrencia: o,
                              aoTocar: () => context.push(
                                RotasNomes.detalheOcorrencia
                                    .replaceFirst(':id', o.id),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
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
}
