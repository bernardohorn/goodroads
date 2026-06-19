import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/cartao_ocorrencia_resumo.dart';
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
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(ocorrenciasListaProvider),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Cores.primariaClara,
                  child: Icon(Icons.add_road, color: Cores.primaria),
                ),
                title: const Text('Registrar ocorrência'),
                subtitle: const Text('Informe problemas em estradas rurais'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(RotasNomes.novaOcorrencia),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Histórico'),
                subtitle: const Text('Veja suas ocorrências anteriores'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(RotasNomes.historico),
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
              error: (e, _) => _ErroCarregamento(
                mensagem: e.toString(),
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
                      child: Text('Nenhuma ocorrência registrada ainda.'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RotasNomes.novaOcorrencia),
        icon: const Icon(Icons.add),
        label: const Text('Nova ocorrência'),
      ),
    );
  }
}

class _ErroCarregamento extends StatelessWidget {
  const _ErroCarregamento({
    required this.mensagem,
    required this.aoTentarNovamente,
  });

  final String mensagem;
  final VoidCallback aoTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Icon(Icons.wifi_off, size: 40, color: Cores.textoSecundario),
          const SizedBox(height: 8),
          Text(mensagem, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: aoTentarNovamente,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
